passport = require 'passport'
util = require 'util'
crypto = require 'crypto'
moment = require 'moment'

Strategy = (options, verify) ->
  if (typeof options == 'function')
    verify = options
    options = {}

  if not verify
    throw new Error('hmac authentication strategy requires a verify function')
  
  @_accessKeyField = options.accessKeyField or 'access-key'
  @_signatureField = options.signatureField or 'signature'
  @_expiryDateField = options.expiryDateField or 'expiry-date'
  
  passport.Strategy.call this
  @name = 'hmac'
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
      return @error err
    else if not user
      return @fail info

    #TODO: get secret from the user id
    verificationSecret = user.apiSecret
    verificationString = stringToSign req
    if not verificationSecret?
      @fail { message: 'User has not activiated API'}
    else
      verificationSignature = hmac verificationSecret
      , verificationString, 'base64'

      if reqSignature != verificationSignature
        @fail {message: 'Signature Verification Failure'}
      else
        @success user, info

  options = options or {}
  accessKey = req.headers[@_accessKeyField]
  reqSignature = req.headers[@_signatureField]
  expiryDate = moment(req.headers[@_expiryDateField])
  systemId = req.systemId or undefined
  
  if not accessKey or not reqSignature
    return @fail({message:'Missing credentials'})
 
  if not expiryDate
    return @fail({message: 'Missing expiry date'})

  if expiryDate < moment()
    return @fail({message: 'Message has expired'})

  if expiryDate > moment().add('minutes', 2)
    return @fail({message: 'expiry date too far in future'})

  if @_passReqToCallback
    @_verify req, accessKey, systemId, verified
  else
    @_verify accessKey, systemId, verified

# Expose `Strategy`.
exports.Strategy = Strategy