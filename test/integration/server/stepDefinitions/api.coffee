moment = require 'moment'
sdk = require 'gint-sdk'
ObjectID = require('mongodb').ObjectID
expect = require('chai').expect
dbHelper = require '../../../lib/dbhelper'

module.exports = () ->
  @World = require('../support/world').World

  @Given /^(?:a|an anonymous api) request to get all (.*)$/, (url, next) ->
    @req = @request.get '/api/' + url
    next()
  
  @When /^the request is addressed to a known host$/, (next) ->
    @req.set('Host', 'test.gint-security.com')
    next()

  @When /^the reply is received$/, (next) ->
    @req.end (err, r) =>
      @res = r
      next()

  @Then /^it should contain (\d) items$/, (num, next) ->
    expect(@res.body, 'body was not defined').to.exist
    expect(@res.body.length).to.equal parseInt(num)
    next()

  @Then /^it replies with a server error$/, (next) ->
    @req.expect(500, next)

  @Then /^it replies with unauthorized$/, (next) ->
    @req.expect(401, next)

  @Then /^it replies with ok$/, (next) ->
    expect(@res.statusCode, "Incorrect statusCode returned").to.equal 200
    next()

  @Then /^it returns with error message (.*) in the response body$/
  , (msg, next) ->
    @req.expect {message: msg}
    next()

  @Then /^it returns nothing in the message body$/, (next) ->
    @req.expect {}
    next()