path = require 'path'
assert = require('chai').assert
expect = require('chai').expect
moment = require 'moment'
mocks = require '../mocks'
sinon = mocks.sinon
dir =  path.normalize __dirname + '../../../../../../server'

module.exports = () ->
  describe 'Roles', ->
    modelFactory = require(dir + '/models/roles')
    model = null
    expectedDefinition =
      name: 'Role'
      schemaDefinition:
        systemId: 'ObjectId'
        name: 'String'
   
    it 'Exports a factory function', (done) ->
      expect(modelFactory).to.be.a 'function'
      done()
    
    describe 'Constructor: (dal) -> { object }', ->
      beforeEach (done) ->
        sinon.spy mocks.dal, 'schemaFactory'
        sinon.spy mocks.dal, 'modelFactory'
        sinon.spy mocks.dal, 'crudFactory'
        model = modelFactory mocks.dal
        done()
      
      afterEach (done) ->
        mocks.dal.modelFactory.restore()
        mocks.dal.schemaFactory.restore()
        mocks.dal.crudFactory.restore()
        done()

      it 'Creates a Roles schema', (done) ->
        expect(mocks.dal.schemaFactory.calledWithMatch(expectedDefinition))
        .to.be.true
        done()

      it 'Creates a Roles model', (done) ->
        returnedDefinition = mocks.dal.schemaFactory.returnValues[0]
        expect(mocks.dal.modelFactory.calledWithMatch(expectedDefinition))
        .to.be.true
        done()

      it 'Uses Crud Factory with returned model', (done) ->
        returnedModel = mocks.dal.modelFactory.returnValues[0]
        expect(mocks.dal.crudFactory.calledWithMatch(returnedModel))
        .to.be.true
        done()

    describe 'Schema', ->
      schema = null

      beforeEach ->
        sinon.spy mocks.dal, 'schemaFactory'
        model = modelFactory mocks.dal
        schema = mocks.dal.schemaFactory.returnValues[0]

      afterEach ->
        mocks.dal.schemaFactory.restore()

      it 'systemId: ObjectId', (done) ->
        expect(schema).to.have.property 'systemId', 'ObjectId'
        done()

      it 'name: String', (done) ->
        expect(schema).to.have.property 'name', 'String'
        done()

    describe 'Exports', ->
      mocks.exportsCrudModel 'Role'
      , modelFactory(mocks.dal)
