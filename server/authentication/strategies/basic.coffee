passport = require 'passport'
util = require 'util'
crypto = require 'crypto'

Strategy = (options, verify) ->
  if (typeof options == 'function')
    verify = options
    options = {}

  if not verify
    throw new Error('basic strategy requires a verify function')
  
  @_userNameField = options.userNameField or 'username'
  @_passwordField = options.passwordField or 'password'

  
  passport.Strategy.call this
  @name = 'basic'
  @_verify = verify
  @_passReqToCallback = options.passReqToCallback
  null

# Inherit from `passport.Strategy`.
util.inherits Strategy, passport.Strategy


Strategy::authenticate = (req, options) ->
  options = options or {}

  username = req.body[@_userNameField] or undefined
  password = req.body[@_passwordField] or undefined
  systemId = req.systemId or undefined

  if not username or not password
    @fail {message: 'Credientials not found'}

  verified = (err, user, info) =>
    if err
      @error err
    else if not user
      @fail info
    else
      @success user, info


  if @_passReqToCallback
    @_verify req, username, password, systemId, verified
  else
    @_verify username, password, systemId, verified

# Expose `Strategy`.
exports.Strategy = Strategy