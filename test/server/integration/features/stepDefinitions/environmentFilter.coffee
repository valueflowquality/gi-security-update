moment = require 'moment'
sdk = require 'gint-sdk'
ObjectID = require('mongodb').ObjectID
expect = require('chai').expect

aTest = () ->
  @World = require('../support/world').World

  req = null
  res = null

  @Given /^a request to get all (.*)$/, (url, next) ->
    req = @request.get '/api/' + url
    next()

  @Given /^is from a valid user$/, (next) ->
    req.set('access-key',  ObjectID('5240630360d7400b18000001'))
    next()

  @Given /^is from an unknown user$/, (next) ->
    req.set('access-key',  ObjectID('5240630360d7400b18000666'))
    next()

  @Given /^a valid expiry date$/, (next) ->
    req.set('expiry-date', moment().add(1, 'minute').unix())
    next()

  @Given /^An authorised User$/, (url, next) ->
    next()

  @Given /^has a valid message signature$/, (next) ->
    parts = []
    parts.push req.req.method
    parts.push req.req._headers.host
    parts.push req.req.path
    parts.push sdk.encodeHeaders(req.req._headers)

    sts = parts.join('\n')
    sig = sdk.signString 'notVerySecret', sts
    req.set('signature', sig)
    next()

  @When /^the request is addressed to an unknown host$/, (next) ->
    req.set('Host', 'bob.com')
    next()
  
  @When /^the request is addressed to a known host$/, (next) ->
    req.set('Host', 'test.gint-security.com')
    next()

  @When /^the reply is received$/, (next) ->
    req.end (err, r) ->
      res = r
      next()

  @Then /^it replies with a server error$/, (next) ->
    req.expect(500, next)

  @Then /^it replies with unauthorized$/, (next) ->
    req.expect(401, next)

  @Then /^it replies with ok$/, (next) ->
    expect(res.statusCode, "Incorrect statusCode returned").to.equal 200
    next()

  @Then /^it returns with error message (.*) in the response body$/
  , (msg, next) ->
    req.expect {message: msg}
    next()

  @Then /^it returns nothing in the message body$/, (next) ->
    req.expect {}
    next()

  @Then /^it returns the list of users in the message body$/, (next) ->
    expect(res.body.length, "Incorrect number of users returned").to.equal 1
    user1 = res.body[0]
    expect(user1.firstName).to.equal 'Alice'
    expect(user1._id).to.equal '5240630360d7400b18000001'
    expect(user1.apiSecret).to.equal 'notVerySecret'
    next()

module.exports = aTest