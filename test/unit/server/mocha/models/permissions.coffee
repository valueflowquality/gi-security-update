path = require 'path'
assert = require('chai').assert
expect = require('chai').expect
moment = require 'moment'
mocks = require '../mocks'
sinon = mocks.sinon

dir =  path.normalize __dirname + '../../../../../../server'

module.exports = () ->
  describe 'Permissions', ->
    model = null
    beforeEach (done) ->
      sinon.spy mocks.dal, 'model'
      model = require(dir + '/models/permissions')(mocks.dal)
      done()
    
    afterEach (done) ->
      mocks.dal.model.restore()
      done()

    it 'Creates a Permissions dal model', (done) ->
      expect(mocks.dal.model.calledWith('Permission'
      , sinon.match.any)).to.be.true
      done()

    describe 'Schema', ->

      it 'systemId: ObjectId', (done) ->
        expect(mocks.dal.model.calledWith('Permission'
        , sinon.match.hasOwn 'systemId', 'ObjectId')).to.be.true
        done()

      it 'userId: ObjectId', (done) ->
        expect(mocks.dal.model.calledWith('Permission'
        , sinon.match.hasOwn 'userId', 'ObjectId')).to.be.true
        done()

      it 'resourceType: String', (done) ->
        expect(mocks.dal.model.calledWith('Permission'
        , sinon.match.hasOwn 'resourceType', 'String')).to.be.true
        done()

      it 'restriction: Number', (done) ->
        expect(mocks.dal.model.calledWith('Permission'
        , sinon.match.hasOwn 'restriction', 'Number')).to.be.true
        done()

      it 'keys: [ObjectId]', (done) ->
        expect(mocks.dal.model.calledWith('Permission'
        , sinon.match.hasOwn 'keys', ['ObjectId'])).to.be.true
        done()


    describe 'Exports',  ->
      mut = require(dir + '/models/permissions')(mocks.dal)
      mocks.exportsCrudModel 'Permission', mut