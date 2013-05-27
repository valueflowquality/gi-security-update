passport = require 'passport'
_ = require 'underscore'

module.exports = (app, models, options) ->

  passport.serializeUser = (user, done) ->
    done null, user.id

  passport.deserializeUser = (obj, done) ->
    models.users.findById obj, (err, user) ->
      if err
        done err, null
      else
        done null, user

  accountCheck = (req, res, next) ->
    #find account by host
    if req.host
      models.accounts.findOneBy 'host', req.host, (err, result) ->
        if err
          res.json 500, {message: err}
        else if result
          req.accountId = result._id
          next()
        else
          res.json 404, {message: 'host account not found'}
    else
      res.json 500, {message: 'host not found on request object'}

  publicAction = (req, res, next) ->
    accountCheck req, res, next

  hmacAuth = (req, res, next) ->
    if _.indexOf(options.strategies, 'Hmac') is -1
      next 'Hmac strategy not supported', null
    else  
      passport.authenticate('hmac', (err, user, info) ->
        if err
          next err, null
        else if not user
          next info, null
        else
          console.log 'user is authenticated via hmac'
          next null, user
      )(req, res, next)

  playAuth = (req, res, next) ->
    if _.indexOf(options.strategies, 'Play') is -1
      next 'Play strategy not supported', null
    else
      passport.authenticate('play', (err, user, info) ->
        if err
          next err, null
        else if not user
          next info, null
        else
          console.log 'user is authenticated via play'
          next null, user
      )(req, res, next)

  userAction = (req, res, next) ->
    accountCheck req, res, () ->
      if req.isAuthenticated()
        next()
      else
        hmacAuth req, res, (err, user) ->
          if user and (not err)
            next()
          else
            console.log 'attempting play auth'
            playAuth req, res, (err, user) ->
              console.log 'play auth ' + err + ' : ' + user
              if user and (not err)
                next()
              else
                res.json 401, {}

  adminAction = (req, res, next) ->
    userAction req, res, () ->
      #so we know we're logged in
      #TODO: check roles
      next()

  sysAdminAction = (req, res, next) ->
    userAction req, res, () ->
      #so we know we're logged in
      #TODO: check roles
      next()

  loginStatus = (req, res) ->
    if req.isAuthenticated()
      res.json 200, { loggedIn: true }
    else
      res.json 200, { loggedIn: false }

  logout = (req, res) ->
    req.logout()
    res.send 200

  #Configure Passport authentication strategies
  users = models.users
  if options.strategies?
    if _.indexOf(options.strategies, 'Basic') > -1
      basic = require('./basic')(users)
    if _.indexOf(options.strategies, 'Facebook') > -1
      facebook = require('./facebook')(users)
    if _.indexOf(options.strategies, 'Hmac') > -1
      require('./hmac')(users)
    if _.indexOf(options.strategies, 'Play') > -1
      require('./play')(users)

  app.use passport.initialize()
  app.use passport.session()
  app.use app.router

  #Having fired up passport authentication
  #link in the authentication routes:

  app.get   '/api/loginstatus', loginStatus
  app.get   '/api/logout', logout

  if options.strategies?
    if _.indexOf(options.strategies, 'Basic') > -1
      basic.routes app
    if _.indexOf(options.strategies, 'Facebook') > -1
      facebook.routes app

  #Export the authentiaction action middleware
  publicAction: publicAction
  userAction: userAction
  adminAction: adminAction
  sysAdminAction: sysAdminAction