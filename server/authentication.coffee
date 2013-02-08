util = require 'util'
path = require 'path'
passport = require 'passport'
dir = path.normalize __dirname + "/views"

module.exports = (app, mongoose, options) ->
  models = require('./models/models')(mongoose)
  users = models.users
  FacebookStrategy = require('passport-facebook').Strategy
  HmacStrategy = require('./hmac').Strategy

  FACEBOOK_APP_ID = options.FACEBOOK_APP_ID
  FACEBOOK_APP_SECRET =  options.FACEBOOK_APP_SECRET
  DOMAIN_URI = options.DOMAIN_URI

  passport.serializeUser = (user, done) ->
    done null, user.id

  passport.deserializeUser = (obj, done) ->
    users.findOneById obj, (err, user) ->
      if err
        done err, null
      else
        done null, user

  publicAction = (req, res, next) ->
    next()

  userAction = (req, res, next) ->
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
        , provider_id : profile.id
        , user_ids: [{provider: 'Facebook', provider_id: profile.id}] }
        , (err, user) ->
          done(null, user)
  )

  passport.use new HmacStrategy((accessKey, done) ->
    # if there is an error , we should return:    #   done(err)
    users.findOneById accessKey, (err, user) ->
      if err
        done err
      else if not user
        #valid hmac, but unknown user
        done null, false, { message: 'No user found with that accessKey'}
      else
        #success, the access Key is associated with a user
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

  app.get     '/api/loginstatus', loginStatus
  app.get     '/api/logout', logout

  publicAction: publicAction
  userAction: userAction
  adminAction: adminAction
  sysAdminAction: sysAdminAction