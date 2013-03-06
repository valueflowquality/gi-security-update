should = require 'should'
path = require 'path'

dir =  path.normalize __dirname + '../../../../server'

describe 'Account Controller', ->
  mockModel = require '../mocks/crud'
  controller = require(dir + '/controllers/account')(mockModel)

  it 'Has an index method', (done) ->
    controller.should.have.ownProperty 'index'
    done()

  it 'Has a create method', (done) ->
    controller.should.have.ownProperty 'create'
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