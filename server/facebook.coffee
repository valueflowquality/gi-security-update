passport = require 'passport'
util = require 'util'
crypto = require 'crypto'
moment = require 'moment'

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

uriEscape= (string) ->
  uri = escape(string).replace(/\+/g, '%2B').replace(/\//g, '%2F')
  uri = uri.replace(/%7E/g, '~').replace(/\=/g, '%3D')

encodeProperty = (key, value) ->
  uriEscape(key) + '=' + uriEscape(value)

encodeHeaders = (headers) ->
  result = ""
  if headers['access-key']
    result += encodeProperty('access-key', headers['access-key'])
  if headers['expiry-date']
    result += '&' + encodeProperty('expiry-date', headers['expiry-date'])
  result

stringToSign = (req) ->
  parts = []
  parts.push req.method
  parts.push req.headers.host
  parts.push req.path
  parts.push encodeHeaders(req.headers)
  parts.join '\n'

hmac = (key, string, digest, fn) ->
  if not digest
    digest = 'binary'
  if not fn
    fn = 'sha256'
  crypto.createHmac(fn, new Buffer(key, 'utf8')).update(string).digest(digest)

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

  if not response
    return @fail({message:'Missing facebook response'})
 
  if @_passReqToCallback
    @_verify req, response.userID, verified
  else
    @_verify response.userID, verified

# Expose `Strategy`.
exports.Strategy = Strategy