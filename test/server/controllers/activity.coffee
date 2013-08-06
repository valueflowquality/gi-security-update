path = require 'path'
sinon = require 'sinon'
assert = require('chai').assert
expect = require('chai').expect
mocks = require '../mocks'

dir =  path.normalize __dirname + '../../../../server'

module.exports = () ->
  describe 'Activity', ->

    models =
      activities:
        name: 'activities'
        create: ->
   
    controller = require(dir + '/controllers/activity')(models.activities, mocks.crudControllerFactory)

    it 'Has an index method', (done) ->
      expect(controller).to.have.ownProperty 'index'
      done()

    it 'Has a create method', (done) ->
      expect(controller).to.have.ownProperty 'create'
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
      expect(controller).to.have.ownProperty 'show'
      done()

    it 'Has an update method', (done) ->
      expect(controller).to.have.ownProperty 'update'
      done()

    it 'Has a destroy method', (done) ->
      expect(controller).to.have.ownProperty 'destroy'
      done()