util = require 'util'
path = require 'path'
passport = require 'passport'
dir = path.normalize __dirname + "/views"
http = require 'http'

module.exports = (app, models, options) ->
  users = models.users
  accounts = models.accounts

  FacebookStrategy = require('./facebook').Strategy
  HmacStrategy = require('./hmac').Strategy
  LocalStrategy = require('./basic').Strategy

  FACEBOOK_APP_ID = options.FACEBOOK_APP_ID
  FACEBOOK_APP_SECRET =  options.FACEBOOK_APP_SECRET
  DOMAIN_URI = options.DOMAIN_URI

  passport.serializeUser = (user, done) ->
    done null, user.id

  passport.deserializeUser = (obj, done) ->
    users.findById obj, (err, user) ->
      if err
        done err, null
      else
        done null, user

  accountCheck = (req, res, next) ->
    #find account by host
    if req.host
      accounts.findOneBy 'host', req.host, (err, result) ->
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

  userAction = (req, res, next) ->
    accountCheck req, res, () ->
      if req.isAuthenticated()
        next()
      else
        #the user was not authenticated via cookies, try hmac
        passport.authenticate('hmac', (err, user, info) ->
          if err
            next(err)
          else if not user
            console.log info
            res.json 401, info
          else
            console.log 'user is authenticated via hmac'
            req.user = user
            next()
        )(req, res, next)

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

  passport.use new HmacStrategy((accessKey, done) ->
    # if there is an error , we should return:    #   done(err)
    users.findById accessKey, (err, user) ->
      if err
        done err
      else if not user
        #valid hmac, but unknown user
        done null, false, { message: 'No user found with that accessKey'}
      else
        #success, the access Key is associated with a user
        done null, user
  )

  passport.use new LocalStrategy((email, password, done) ->
    users.findOneBy 'email', email, (err, user) ->
      if err
        done null, false, {message: err}
      else if not user
        done null, false, {message: 'User not found'}
      else
        user.comparePassword password, (err, isValid) ->
          if err
            done err
          else if not isValid
            done null, false, {message: 'Incorrect password'}
          else
            done null, user
  )

  facebookOptions =
    clientID: FACEBOOK_APP_ID
    clientSecret: FACEBOOK_APP_SECRET
    domain: DOMAIN_URI

  passport.use new FacebookStrategy(facebookOptions
  , (facebookid, done) ->
    http.get "http://graph.facebook.com/" +
    facebookid + "?fields=id%2Cname", (res) ->

      data = ''

      res.on 'data', (chunk) ->
        data += chunk

      res.on 'end', () ->
        body = JSON.parse data
        users.findOrCreate
          name: body.name
          providerId : body.id
          userIds: [{provider: 'Facebook', providerId: body.id}]
        , (err, user) ->
          done(err, user)

    .on 'error', (e) ->
      done e.message, null
  )

  app.use passport.initialize()
  app.use passport.session()
  app.use app.router

  app.post '/api/login'
  , passport.authenticate('basic')
  , (req, res) ->
    res.json 200

  app.post '/api/loginviafacebook'
  , passport.authenticate('facebook-sdk')
  , (req, res) ->
    res.json 200

  app.get   '/api/loginstatus', loginStatus
  app.get   '/api/logout', logout

  publicAction: publicAction
  userAction: userAction
  adminAction: adminAction
  sysAdminAction: sysAdminAction