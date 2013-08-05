path = require 'path'
sinon = require 'sinon'
should = require('chai').should()
assert = require('chai').assert
moment = require 'moment'
mocks = require '../mocks'

dir =  path.normalize __dirname + '../../../../server'

describe 'Roles Model', ->

  model = require(dir + '/models/roles')(mocks.mongoose, mocks.crudModelFactory)

  it 'Creates a Role mongoose model', (done) ->
    mocks.mongoose.model.calledWith('Role'
    , sinon.match.any).should.be.true
    done()

  describe 'Schema', ->

    it 'systemId: ObjectId', (done) ->
      mocks.mongoose.model.calledWith('Role'
      , sinon.match.hasOwn 'systemId', 'ObjectId').should.be.true
      done()

    it 'name: String', (done) ->
      mocks.mongoose.model.calledWith('Role'
      , sinon.match.hasOwn 'name', 'String').should.be.true
      done()

  describe 'Exports',  ->
     mocks.exportsCrudModel 'Role', model
