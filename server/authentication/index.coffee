passport = require 'passport'
_ = require 'underscore'
async = require 'async'

permissionFilter = require './permissionFilter'

module.exports = (app) ->
  permissionsMiddleware = permissionFilter app

  passport.serializeUser = (user, done) ->
    obj =
      _id: user._id
      systemId: user.systemId

    done null, obj

  passport.deserializeUser = (obj, done) ->
    app.models.users.findById obj._id, obj.systemId, (err, user) ->
      if err
        done err, null
      else
        done null, user

  getSystemStrategies = (req, callback) ->

    getSecuritySetting = (name, param, cb) ->
      app.models.settings.get name, req.systemId, req.environmentId
      , (err, result) ->
        if err
          cb(err) if cb
        else if result?.value
          cb(null, param) if cb

    async.parallel [
      (cb) ->
        getSecuritySetting 'loginWithFacebook', 'facebook', cb
      , (cb) ->
        getSecuritySetting 'loginWithHmac', 'Hmac', cb
      , (cb) ->
        getSecuritySetting 'loginWithPlay', 'Play', cb
    ], (err, results) ->
      if err
        callback(err, null) if callback
      else
        callback(err, results) if callback

  systemCheck = (req, res, next) ->
    #find environment by host
    if req?.host
      app.models.environments.forHost req.host, (err, result) ->
        if err
          res.json 500, {message: err}
        else if result
          req.systemId = result.systemId
          req.environmentId = result._id
          exports._getSystemStrategies req, (err, strategies) ->
            if strategies? and not err
              req.strategies = strategies
            next()
        else
          res.json 404, {message: 'environment not found'}
    else
      res.json 500, {message: 'host not found on request object'}

  publicAction = (req, res, next) ->
    exports._systemCheck req, res, next

  hmacAuth = (req, res, next) ->
    if _.indexOf(req.strategies, 'Hmac') is -1
      next 'Hmac strategy not supported', null
    else
      passport.authenticate('hmac', (err, user, info) ->
        if err
          next err, null
        else if not user
          next info, null
        else
          req.user = user
          next null, user
      )(req, res, next)

  playAuth = (req, res, next) ->
    if _.indexOf(req.strategies, 'Play') is -1
      next 'Play strategy not supported', null
    else
      passport.authenticate('play', (err, user, info) ->
        if err
          next err, null
        else if not user
          next info, null
        else
          req.user = user
          next null, user
      )(req, res, next)

  userAction = (req, res, next) ->
    exports.publicAction req, res, () =>
      if req.isAuthenticated()
        permissionsMiddleware req, res, next
      else
        exports._hmacAuth req, res, (err, user) =>
          if user and (not err)
            permissionsMiddleware req, res, next
          else
            exports._playAuth req, res, (err, user) ->
              if user and (not err)
                permissionsMiddleware req, res, next
              else
                res.json 401, {}

  adminAction = (req, res, next) ->
    userAction req, res, () ->
      isAdmin req.user, (ok) ->
        if ok
          next()
        else
          res.json 401, {}

  sysAdminAction = (req, res, next) ->
    userAction req, res, () ->
      isSysAdmin req.user, (ok) ->
        if ok
          next()
        else
          res.json 401, {}

  isInRole = (role, user, callback) ->
    result = false
    app.models.roles.findOneBy 'name', role, user.systemId
    , (err, obj) ->
      if obj and not err
        _.each(user.roles, (role) ->
          if role.toString() is obj._id.toString()
            result = true
        )
        callback(result) if callback
      else
        callback(false) if callback

  isRestricted = (user, callback) ->
    isInRole 'Restricted', user, callback

  isAdmin = (user, callback) ->
    isInRole 'Admin', user, callback

  isSysAdmin = (user, callback) ->
    isInRole 'SysAdmin', user, callback

  loginStatus = (req, res) ->
    if req.isAuthenticated()
      isAdmin req.user, (isA) ->
        isRestricted req.user, (isR) ->
          res.json 200, { loggedIn: true, isAdmin: isA, isRestricted: isR }
    else
      res.json 200, { loggedIn: false, isAdmin: false, isRestricted: true }

  logout = (req, res) ->
    req.logout()
    res.send 200

  #Configure Passport authentication strategies
  users = app.models.users
  basic = require('./basic')(users)
  facebook = require('./facebook')(users)
  require('./hmac')(users)
  require('./play')(users)

  app.use passport.initialize()
  app.use passport.session()
  app.use app.router

  #Having fired up passport authentication
  #link in the authentication routes:

  app.get   '/api/loginstatus', loginStatus
  app.get   '/api/logout', logout
  basic.routes app, publicAction
  facebook.routes app, publicAction

  exports =
  #Export the authentiaction action middleware
    publicAction: publicAction
    userAction: userAction
    adminAction: adminAction
    sysAdminAction: sysAdminAction
    _getSystemStrategies: getSystemStrategies
    _systemCheck: systemCheck
    _hmacAuth: hmacAuth
    _playAuth: playAuth

  exports