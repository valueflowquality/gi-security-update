path = require 'path'
assert = require('chai').assert
expect = require('chai').expect
moment = require 'moment'
mocks = require '../mocks'

dir =  path.normalize __dirname + '../../../../../server'

module.exports = () ->
  describe 'Settings', ->

    model = require(dir + '/models/settings')(
      mocks.mongoose, mocks.crudModelFactory
    )
    
    modelName = 'Setting'    
    sinon = mocks.sinon
    
    it 'Creates a Settings mongoose model', (done) ->
      expect(mocks.mongoose.model.calledWith(modelName
      , sinon.match.any)).to.be.true
      done()

    describe 'Schema', ->

      it 'systemId: ObjectId', (done) ->
        expect(mocks.mongoose.model.calledWith(modelName
        , sinon.match.hasOwn 'systemId', 'ObjectId')).to.be.true
        done()

      it 'key: String', (done) ->
        expect(mocks.mongoose.model.calledWith(modelName
        , sinon.match.hasOwn 'key', 'String')).to.be.true
        done()

      it 'value: String', (done) ->
        expect(mocks.mongoose.model.calledWith(modelName
        , sinon.match.hasOwn 'value', 'String')).to.be.true
        done()

      it 'parent: {key: ObjectId, resourcetype: String}', (done) ->
        expect(mocks.mongoose.model.calledWith(modelName
        , sinon.match.hasOwn 'parent'
        , {key: 'ObjectId', resourceType: 'String'})
        ).to.be.true
        done()

    describe 'Exports',  ->
      mocks.exportsCrudModel modelName, model
      
      describe 'Overriden Crud', ->
        it 'Has no overridden crud', (done) ->
          done()
          
      describe 'Other', ->
        it 'get: function(name, systemId, environmentId, callback) -> (err, obj)', (done) ->
          done()

        it 'set: function(name, value, systemId, environmentId, callback) -> (err)' +
        '-> (err, obj)', (done) ->
          done()