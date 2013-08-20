path = require 'path'
assert = require('chai').assert
expect = require('chai').expect
moment = require 'moment'
mocks = require '../mocks'

dir =  path.normalize __dirname + '../../../../server'

module.exports = () ->
  describe 'Permissions', ->

    model = require(dir + '/models/permissions')(
      mocks.mongoose, mocks.crudModelFactory
    )
    
    sinon = mocks.sinon
    it 'Creates a Permissions mongoose model', (done) ->
      expect(mocks.mongoose.model.calledWith('Permission'
      , sinon.match.any)).to.be.true
      done()

    describe 'Schema', ->

      it 'systemId: ObjectId', (done) ->
        expect(mocks.mongoose.model.calledWith('Permission'
        , sinon.match.hasOwn 'systemId', 'ObjectId')).to.be.true
        done()

      it 'userId: ObjectId', (done) ->
        expect(mocks.mongoose.model.calledWith('Permission'
        , sinon.match.hasOwn 'userId', 'ObjectId')).to.be.true
        done()

      it 'resourceType: String', (done) ->
        expect(mocks.mongoose.model.calledWith('Permission'
        , sinon.match.hasOwn 'resourceType', 'String')).to.be.true
        done()

      it 'restriction: Number', (done) ->
        expect(mocks.mongoose.model.calledWith('Permission'
        , sinon.match.hasOwn 'restriction', 'Number')).to.be.true
        done()

      it 'keys: [ObjectId]', (done) ->
        expect(mocks.mongoose.model.calledWith('Permission'
        , sinon.match.hasOwn 'keys', ['ObjectId'])).to.be.true
        done()


    describe 'Exports',  ->
      mocks.exportsCrudModel 'Permission', model