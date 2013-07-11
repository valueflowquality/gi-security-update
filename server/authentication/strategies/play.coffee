passport = require 'passport'
util = require 'util'
http = require 'http'
_ = require 'underscore'

Strategy = (options, verify) ->
  if (typeof options == 'function')
    verify = options
    options = {}

  if not verify
    throw new Error('play strategy requires a verify function')
  
  @_cookieField = options.cookieName or 'PLAY_SESSION'
  
  passport.Strategy.call this
  @name = 'play'
  @_verify = verify
  @_passReqToCallback = options.passReqToCallback
  return

# Inherit from `passport.Strategy`.
util.inherits Strategy, passport.Strategy

Strategy::authenticate = (req) ->
  if req.headers.cookie?

    cookies = req.headers.cookie.split ';'
    playCookie = _.find cookies, (cookie) =>
      cookie.split('=')[0].trim() is @_cookieField

    if playCookie?
      userId = playCookie.split('-user_id%3A')[1]

      playRequestOptions =
        host: req.host
        port: 80
        path: '/cookievalidator'
        headers:
          Cookie: playCookie
          ContentType: 'application/json'


      verified = (err, user, info) =>
        if err
          @error err
        else if not user
          @fail info
        else
          @success user, info

      that = @
      playRequest = http.request playRequestOptions, (res) ->

        if res.statusCode is 200
          if that._passReqToCallback
            that._verify req, userId, verified
          else
            that._verify userId, verified
        else
          console.log 'STATUS: ' + res.statusCode
          that.fail { message: 'Not Authorized'}
      
      playRequest.on 'error', (e) ->
        that.fail { message: 'problem with request: ' + e.message }
      
      playRequest.end()

    else
      @fail 'Not signed into play'
  else
    @fail 'No cookie found on request'

# Expose `Strategy`.
exports.Strategy = Strategy