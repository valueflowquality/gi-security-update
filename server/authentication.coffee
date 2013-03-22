util = require 'util'
path = require 'path'
passport = require 'passport'
dir = path.normalize __dirname + "/views"

module.exports = (app, models, options) ->
  users = models.users
  accounts = models.accounts

  FacebookStrategy = require('passport-facebook').Strategy
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
        console.log 'user is authenticated via session cookie'
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

  facebookCallback = (req, res) ->
    res.sendfile dir + '/success.html'

  emptyAction = (req, res) ->
    {}

  loginStatus = (req, res) ->
    if req.isAuthenticated()
      res.json 200, { loggedIn: true }
    else
      res.json 200, { loggedIn: false }

  logout = (req, res) ->
    req.logout()
    res.send 200

  passport.use new FacebookStrategy(
    { clientID: FACEBOOK_APP_ID
    , clientSecret: FACEBOOK_APP_SECRET
    , callbackURL: DOMAIN_URI + "/auth/facebook/callback"}
    , (accessToken, refreshToken, profile, done) ->
      # asynchronous verification, for effect...
      process.nextTick () ->
        users.findOrCreate { name: profile.displayName
        , providerId : profile.id
        , userIds: [{provider: 'Facebook', providerId: profile.id}] }
        , (err, user) ->
          done(err, user)
  )

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

  # FACEBOOK authentication routes
  #   The first step in Facebook authentication will involve
  #   redirecting the user to facebook.com.  After authorization, Facebook will
  #   redirect the user back to this application at /auth/facebook/callback
  #

  app.use passport.initialize()
  app.use passport.session()
  app.use app.router

  app.get '/auth/facebook'
  , passport.authenticate 'facebook' #middleware that redirects us onto facebook
  , emptyAction #this will not be called, as we will have been redirected

  app.get '/auth/facebook/callback'
  , passport.authenticate('facebook', { failureRedirect: '/' })
  , facebookCallback

  app.post '/api/login'
  , passport.authenticate('basic')
  , (req, res) ->
    res.json 200

  app.get   '/api/loginstatus', loginStatus
  app.get   '/api/logout', logout

  publicAction: publicAction
  userAction: userAction
  adminAction: adminAction
  sysAdminAction: sysAdminAction