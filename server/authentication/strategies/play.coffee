passport = require 'passport'
util = require 'util'
http = require 'http'

Strategy = (options, verify) ->
  if (typeof options == 'function')
    verify = options
    options = {}

  if not verify
    throw new Error('play strategy requires a verify function')
  
  @_cookieField = options.userNameField or 'PLAY_SESSION'
  
  passport.Strategy.call this
  @name = 'play'
  @_verify = verify
  @_passReqToCallback = options.passReqToCallback
  return

# Inherit from `passport.Strategy`.
util.inherits Strategy, passport.Strategy

Strategy::authenticate = (req, options) ->
  options = options or {}
  console.log req.cookies.PLAY_SESSION
  userId = req.cookies[@_cookieField].split('-')[1].split(':')[1] or undefined

  playRequestOptions =
    host: 'dev.seasonedcourses.com'
    port: 9000
    path: '/cookievalidator'
    headers:
      #Cookie: 'PLAY_SESSION=' + req.cookies.PLAY_SESSION
      Cookie: 'PLAY_SESSION=9203a2ec6cc9d8c2038dfc611b3e707a60fa11cd-user_id%3A4e47cefbdcbdc3241994d0f8'
      ContentType: 'application/json'
  
  console.log 'about to request'
  console.log playRequestOptions.headers.Cookie

  verified = (err, user, info) =>
    if err
      @error err
    else if not user
      @fail info
    else
      @success user, info

  playRequest = http.request playRequestOptions, (res) ->
    console.log 'STATUS: ' + res.statusCode
    if res.statusCode is 200
      if @_passReqToCallback
        @_verify req, userId, verified
      else
        @_verify userId, verified
    else
      @fail { message: 'Not Authorized'}
  
  playRequest.on 'error', (e) ->
    @fail { message: 'problem with request: ' + e.message }
  
  playRequest.end()

# Expose `Strategy`.
exports.Strategy = Strategy