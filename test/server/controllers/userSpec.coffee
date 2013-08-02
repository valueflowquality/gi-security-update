_ = require 'underscore'
path = require 'path'
assert = require('chai').assert
should = require('chai').should()
sinon = require 'sinon'

mocks = require '../mocks'

dir =  path.normalize __dirname + '../../../../server'

describe 'User Controller', ->

  alice = 
    firstName: 'Alice'
    password: '123'
  
  bob =
    firstName: 'Bob'
    password: '456'

  userModel =
    name: 'activities'
    create: (json, cb) ->
      cb null, json
    find: (options, cb) ->
      cb null, [alice, bob]
    findById: (id, systemId, cb) ->
      cb null, alice
    update: (id, json, cb) ->
      cb null, json
 
  controller = require(dir + '/controllers/user')(userModel, mocks.crudControllerFactory)

  describe 'exports', ->
    it 'an index method', (done) ->
      controller.should.have.ownProperty 'index'
      done()

    it 'a create method', (done) ->
      controller.should.have.ownProperty 'create'
      done()

    it 'a show method', (done) ->
      controller.should.have.ownProperty 'show'
      done()

    it 'an update method', (done) ->
      controller.should.have.ownProperty 'update'
      done()

    it 'a destroy method', (done) ->
      controller.should.have.ownProperty 'destroy'
      done()

  describe 'Index', ->
    it 'Does not transmit passwords', (done) ->
      req =
        query:
          max: 3
      res =
        json: (code, result) ->
          _.each result, (user) ->
            should.not.exist(user.password)
            user.should.not.have.property 'password'
          done()
      controller.index req, res

  describe 'Show', ->
    it 'Does not transmit passwords', (done) ->
      req =
        params:
          id: 'validId'
      res =
        json: (code, result) ->
          should.not.exist result.password
          result.should.not.have.property 'password'
          done()
      controller.show req, res

  describe 'Create', ->
    it 'Does not transmit passwords', (done) ->
      req =
        body:
          firstName: 'Bob'
          password: 'a plain password'
      res =
        json: (code, result) ->
          should.not.exist result.password
          result.should.not.have.property 'password'
          done()
      controller.create req, res

  describe 'Update', ->
    it 'Does not transmit passwords', (done) ->
      req =
        params:
          id: '123'
        body:
          firstName: 'Bob'
          password: 'a plain password'
      res =
        json: (code, result) ->
          should.not.exist result.password
          result.should.not.have.property 'password'
          done()
      controller.update req, res

  describe 'showMe', ->
    it 'Does not transmit passwords', (done) ->
      req =
        user:
          id: 'validId'
      res =
        json: (code, result) ->
          should.not.exist result.password
          result.should.not.have.property 'password'
          done()
      controller.showMe req, res

  describe 'UpdateMe', ->
    it 'Does not transmit passwords', (done) ->
      req =
        user:
          id: '123'
        body:
          _id: '123'
          password: 'a password'
      res =
        json: (code, result) ->
          should.not.exist result.password
          result.should.not.have.property 'password'
          done()
      controller.updateMe req, res


