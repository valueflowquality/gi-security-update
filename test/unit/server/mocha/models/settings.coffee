path = require 'path'
assert = require('chai').assert
expect = require('chai').expect
moment = require 'moment'
mocks = require '../mocks'
sinon = mocks.sinon
dir =  path.normalize __dirname + '../../../../../../server'

module.exports = () ->
  describe 'Settings', ->
    model = null
    modelName = 'Setting'

    beforeEach (done) ->
      sinon.spy mocks.dal, 'model'
      model = require(dir + '/models/settings')(mocks.dal)
      done()
    
    afterEach (done) ->
      mocks.dal.model.restore()
      done()
    
    it 'Creates a Settings dal model', (done) ->
      expect(mocks.dal.model.calledWith(modelName
      , sinon.match.any)).to.be.true
      done()

    describe 'Schema', ->
      modelTest = (name, type) ->
        expect(mocks.dal.model.calledWith(modelName
        , sinon.match.hasOwn name, type)
        , name + " not defined correctly on " + modelName).to.be.true

      it 'systemId: ObjectId', ->
        modelTest 'systemId', 'ObjectId'

      it 'key: String', ->
        modelTest 'key', 'String'

      it 'value: String', ->
        modelTest 'value', 'String'

      it 'parent: {key: ObjectId, resourceType: String}', ->
        modelTest 'parent', {key: 'ObjectId', resourceType: 'String'}

      it 'acl: String', ->
        modelTest 'acl', 'String'

    describe 'Exports',  ->
      mut = require(dir + '/models/settings')(mocks.dal)
      mocks.exportsCrudModel modelName, mut
      
      describe 'Overriden Crud', ->
        it 'Has no overridden crud', (done) ->
          done()
          
      describe 'Other', ->
        it 'get: (name, systemId, environmentId, callback) -> (err, obj)'
        , (done) ->
          done()

        it 'set: (name, value, systemId, environmentId, callback) -> (err)' +
        '-> (err, obj)', (done) ->
          done()