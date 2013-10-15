expect = require('chai').expect
sinon = require 'sinon'
path = require 'path'
dir =  path.normalize __dirname + '../../../../../../../server'

module.exports = () ->
  @When /^the authentication module is required$/, (next) ->
    delete require.cache[require.resolve(dir + '/authentication')]
    @mut = require dir + '/authentication'
    next()

  @When /^it is initialized with an express app$/, (next) ->
    @systemId = "systemId"
    @environmentId = "envId"
    envForHost =
      _id: @environmentId
      systemId: @systemId
    app =
      use: sinon.spy()
      get: sinon.spy()
      post: ->
      router: 'app-router'
      models:
        users: 'users'
        environments:
          forHost: (a, cb) ->
            cb null, envForHost
        settings:
          get: (a, b, c, cb) ->
            cb()
    @mut = @mut app
    next()



  @Then /^it exports a (.*) function$/, (functionName, next) ->
    expect(@mut, 'does not export ' + functionName)
    .to.have.ownProperty functionName
    next()

  @Given /^an anonymous request to (.*) (.*)$/, (method, path, next) ->
    @req.route =
      path: path
      method: method.toLowerCase()
    next()

  @Given /^an anonymous request$/, (next) ->
    next()

  @Given /^a request to a known host$/, (next) ->
    @req =
      host: 'test.gint-security.com'
    next()

  @Given /^it should call (.*)$/, (calledMethod, next) ->
    expect(@muts[calledMethod].called, calledMethod + ' not called').to.be.true
    next()

  @When /^this is passed through the (.*) middleware$/, (funcName, next) ->
    @middlewareCallback = sinon.spy()
    @res =
      json: sinon.spy()
    @mut[funcName] @req, @res, @middlewareCallback
    next()
  
  @Then /^it is passed through the (.*) middleware$/, (funcName, next) ->
    expect()
    @middlewareCallback = sinon.spy()
    @res =
      json: sinon.spy()
    @mut[funcName] @req, @res, @middlewareCallback
    next()


  @Then /^the request should be dissalowed$/, (next) ->
    expect(@middlewareCallback.notCalled, "middleware called next incorrectly")
    .to.be.true
    expect(@res.json.calledWith(401), "wrong result code returned").to.be.true
    expect(@res.json.calledWith(401, {msg: 'not authorized'})
    , "wrong error message returned").to.be.true
    next()

  @Then /^the request should be allowed$/, (next) ->
    expect(@middlewareCallback.called, "middleware did not call next")
    .to.be.true
    expect(@res.json.notCalled, 'res.json was called incorrectly').to.be.true
    next()

  @Then /^the request should have a publicRead acl filter applied$/, (next) ->
    expect(@req.query, 'request has no query').to.exist
    expect(@req.query).to.have.ownProperty 'acl'
    expect(@req.query.acl).to.equal 'public-read'
    next()

  @Then /^the request should have a systemId$/, (next) ->
    expect(@req.systemId).to.equal @systemId
    next()