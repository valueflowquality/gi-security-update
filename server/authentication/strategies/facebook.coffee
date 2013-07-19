passport = require 'passport'
util = require 'util'

Strategy = (options, verify) ->
  if (typeof options == 'function')
    verify = options
    options = {}

  if not verify
    throw new Error('facebook sdk authentication strategy ' +
    'requires a verify function')
  
  passport.Strategy.call this
  @name = 'facebook-sdk'
  @_verify = verify
  @_passReqToCallback = options.passReqToCallback
  null

# Inherit from `passport.Strategy`.
util.inherits Strategy, passport.Strategy

Strategy::authenticate = (req, options) ->

  verified = (err, user, info) =>
    if err
      @error err
    else if not user
      @fail info
    else
      @success user, info

  options = options or {}
  
  response = req.body.authResponse
  systemId = req.systemId

  if not response
    return @fail({message:'Missing facebook response'})
 
  if @_passReqToCallback
    @_verify req, response.userID, systemId, verified
  else
    @_verify response.userID, systemId, verified

# Expose `Strategy`.
exports.Strategy = Strategy