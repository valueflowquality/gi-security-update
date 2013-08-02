
path = require 'path'
sinon = require 'sinon'
assert = require('chai').assert
should = require('chai').should()
mocks = require '../mocks'
gint = require 'gint-util'

dir =  path.normalize __dirname + '../../../../server'

describe 'Activity Controller', ->

  models =
    activities:
      name: 'activities'
      create: ->
 
  controller = require(dir + '/controllers/activity')(models.activities, mocks.crudControllerFactory)

  it 'Has an index method', (done) ->
    controller.should.have.ownProperty 'index'
    done()

  it 'Has a create method', (done) ->
    controller.should.have.ownProperty 'create'
    done()

  it 'Adds logged in user id to the request body', (done) ->
    req =
      body:
        description: 'test'
      user:
        id: '123'
    
    json = sinon.spy()
    res =
      json: ->

    createActivity = sinon.stub models.activities, "create"
    createActivity.callsArgWith 1, null, {}

    controller.create req, res

    assert createActivity.called, "not called"
    assert createActivity.calledWith(sinon.match.has("user", req.user.id)
    .and(sinon.match.has("description",req.body.description)))
    , "create activity not called correctly"

   
    createActivity.restore()

    done()

  it 'Has a show method', (done) ->
    controller.should.have.ownProperty 'show'
    done()

  it 'Has an update method', (done) ->
    controller.should.have.ownProperty 'update'
    done()

  it 'Has a destroy method', (done) ->
    controller.should.have.ownProperty 'destroy'
    done()