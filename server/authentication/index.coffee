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

  getSecuritySetting = (name, param, req, cb) ->
    app.models.settings.get name, req.systemId, req.environmentId
    , (err, result) ->
      if err
        cb() if cb
      else if result?.value
        cb(null, param) if cb
      else
        cb() if cb

  getSystemStrategies = (req, callback) ->
    async.parallel [
      (cb) ->
        getSecuritySetting 'loginWithFacebook', 'facebook', req, cb
      , (cb) ->
        getSecuritySetting 'loginWithHmac', 'Hmac', req, cb
      , (cb) ->
        getSecuritySetting 'loginWithPlay', 'Play', req, cb
    ], (err, results) ->
      if err
        callback(err, null) if callback
      else
        isDefined = (value, cb) ->
          cb(value?)
        async.filter results, isDefined, (filteredResults) ->
          callback(err, filteredResults) if callback

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

  publicReadAction = (req, res, next) ->
    if req.route.method is 'get'
      systemCheck req, res, () ->
        if not req.query?
          req.query = {}
        req.query.acl = 'public-read'
        next()
    else
      res.json 401, {msg: 'not authorized'}

  publicRegisterAction = (req, res, next) ->
    systemCheck req, res, () ->
      getSecuritySetting 'allowPublicRegistration'
      , 'allowPublicRegistration', req, (err, setting) ->
        if setting
          next()
        else
          res.json 403, {message: 'Public user registration is not enabled'}

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
    settingName = role + 'RoleName'

    app.models.settings.get settingName, user.systemId, (err, result) ->
      roleName = role
      if result?.value
        roleName = result.value
      app.models.roles.findOneBy 'name', roleName, user.systemId
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
    return

  isAdmin = (user, callback) ->
    isInRole 'Admin', user, (result) ->
      if result
        callback(result) if callback
      else
        isSysAdmin user, callback
    return

  isSysAdmin = (user, callback) ->
    isInRole 'SysAdmin', user, callback
    return

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

  app.get   '/api/logout', logout
  basic.routes app, publicAction
  facebook.routes app, publicAction

  exports =
  #Export the authentiaction action middleware
    publicAction: publicAction
    publicReadAction: publicReadAction
    userAction: userAction
    adminAction: adminAction
    sysAdminAction: sysAdminAction
    publicRegisterAction: publicRegisterAction
    _getSystemStrategies: getSystemStrategies
    _systemCheck: systemCheck
    _hmacAuth: hmacAuth
    _playAuth: playAuth

  exports