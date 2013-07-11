should = require 'should'
path = require 'path'
gint = require 'gint-util'
sinon = require 'sinon'
assert = require 'assert'

dir =  path.normalize __dirname + '../../../server'

describe 'Application Routes', ->
  module = require(dir + '/routes')

  assertRestfulForResource = (resource) ->
    api =
      user:
        showMe: sinon.spy()
        updateMe: sinon.spy()
        destroyMe: sinon.spy()
        index: sinon.spy()
      role: sinon.spy()
      setting: sinon.spy()
      activity: sinon.spy()
      category: sinon.spy()

    app =
      get: sinon.spy()
      post: sinon.spy()
      del: sinon.spy()
      put: sinon.spy()

    security =
      auth: sinon.spy()
      models: sinon.spy()
    router = module(app, security.auth, api)

    assert app.get.calledWith('/api/' + resource), "Get failed"
    assert app.del.calledWith('/api/' + resource + '/:id'), "Del failed"
    assert app.put.calledWith('/api/' + resource + '/:id'), "Put failed"
    assert app.post.calledWith('/api/' + resource), "Post failed"

  it 'exports a RESTful role resource', (done) ->
    assertRestfulForResource 'roles'
    done()

  it 'exports a RESTful users resource', (done) ->
    assertRestfulForResource 'users'
    done()

  it 'exports a RESTful settings resource', (done) ->
    assertRestfulForResource 'settings'
    done()

  it 'exports a RESTful activities resource', (done) ->
    assertRestfulForResource 'activities'
    done()

  it 'exports a Restful categories resource', (done) ->
    assertRestfulForResource 'categories'
    done()