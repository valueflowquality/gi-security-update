path = require 'path'
assert = require('chai').assert
expect = require('chai').expect
moment = require 'moment'
mocks = require '../mocks'
sinon = mocks.sinon
dir =  path.normalize __dirname + '../../../../../../server'

module.exports = () ->
  describe 'Settings', ->
    modelFactory = require dir + '/models/settings'
    model = null
    modelName = 'Setting'
    schema = null
    
    beforeEach ->
      sinon.spy mocks.dal, 'schemaFactory'
      model = modelFactory mocks.dal
      schema = mocks.dal.schemaFactory.returnValues[0]

    afterEach ->
      mocks.dal.schemaFactory.restore()

    it 'Exports a factory function', (done) ->
      expect(modelFactory).to.be.a 'function'
      done()
    
    describe 'Schema', ->

      modelTest = (name, type) ->
        expect(schema).to.have.property name, type

      it 'systemId: ObjectId', ->
        modelTest 'systemId', 'ObjectId'

      it 'key: String', ->
        modelTest 'key', 'String'

      it 'value: String', ->
        modelTest 'value', 'String'

      it 'acl: String', ->
        modelTest 'acl', 'String'

      it 'parent: {key: ObjectId, resourceType: String}', ->
        expect(schema).to.have.property 'parent'
        expect(schema.parent).to.be.an 'object'
        expect(schema.parent).to.deep.equal {key: 'ObjectId', resourceType: 'String'}

    describe 'Exports',  ->
      mocks.exportsCrudModel 'Setting', modelFactory(mocks.dal)
      
      describe 'Overriden Crud', ->
        it 'Has no overridden crud', (done) ->
          done()
          
      describe 'Other', ->
        it 'get: (name, systemId, environmentId, callback) -> (err, obj)'
        , (done) ->
          expect(model).to.have.ownProperty 'get'
          expect(model.get).to.be.a 'function'
          done()
        
        it 'set: (name, value, systemId, environmentId, callback) -> (err)' +
        '-> (err, obj)', (done) ->
          expect(model).to.have.ownProperty 'set'
          expect(model.set).to.be.a 'function'
          done()

    describe 'Private', ->
      it '_getEnvironment: (name, systemId, environmentId, callback) ' +
      '-> (err, obj)' , (done) ->
        expect(model).to.have.ownProperty '_getEnvironment'
        expect(model._getEnvironment).to.be.a 'function'
        done()

      it '_getSystem: (name, systemId, callback) -> (err, obj)', (done) ->
        expect(model).to.have.ownProperty '_getSystem'
        expect(model._getSystem).to.be.a 'function'
        done()

      it '_saveSetting: (name, value, systemId, environmentId, callback) ' +
      '(err, obj)', (done) ->
        expect(model).to.have.ownProperty '_saveSetting'
        expect(model._saveSetting).to.be.a 'function'
        done()

