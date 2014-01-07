path = require 'path'
assert = require('chai').assert
expect = require('chai').expect
moment = require 'moment'
mocks = require '../mocks'
sinon = mocks.sinon

dir =  path.normalize __dirname + '../../../../../../server'

module.exports = () ->
  describe 'Permissions', ->
    modelFactory = require dir + '/models/permissions'
    model = null

    expectedDefinition =
      name: 'Permission'
      schemaDefinition:
        systemId: 'ObjectId'
        userId: 'ObjectId'
        resourceType: 'String'
        restriction: 'Number'
        keys: ['ObjectId']

    it 'Exports a factory function', (done) ->
      expect(modelFactory).to.be.a 'function'
      done()

    describe 'Constructor: (dal) -> { object }', ->
      beforeEach ->
        sinon.spy mocks.dal, 'schemaFactory'
        sinon.spy mocks.dal, 'modelFactory'
        sinon.spy mocks.dal, 'crudFactory'
        model = modelFactory mocks.dal

      afterEach ->
        mocks.dal.modelFactory.restore()
        mocks.dal.schemaFactory.restore()
        mocks.dal.crudFactory.restore()

      it 'Creates a resources schema', (done) ->
        expect(mocks.dal.schemaFactory.calledWithMatch(expectedDefinition))
        .to.be.true
        done()

      it 'Creates a resources model', (done) ->
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

      it 'userId: ObjectId', (done) ->
        expect(schema).to.have.property 'userId', 'ObjectId'
        done()

      it 'resourceType: String', (done) ->
        expect(schema).to.have.property 'resourceType', 'String'
        done()

      it 'restriction: Number', (done) ->
        expect(schema).to.have.property 'restriction', 'Number'
        done()

      it 'keys: [ObjectId]', (done) ->
        expect(schema).to.have.property 'keys'
        expect(schema.keys).to.be.an 'array'
        expect(schema.keys.length).to.equal 1
        expect(schema.keys[0]).to.equal 'ObjectId'
        done()

    describe 'Exports',  ->
      mut = require(dir + '/models/permissions')(mocks.dal)
      mocks.exportsCrudModel 'Permission', mut