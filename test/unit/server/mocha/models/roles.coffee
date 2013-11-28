path = require 'path'
assert = require('chai').assert
expect = require('chai').expect
moment = require 'moment'
mocks = require '../mocks'
sinon = mocks.sinon
dir =  path.normalize __dirname + '../../../../../../server'

module.exports = () ->
  describe 'Roles', ->
    model = null
    beforeEach (done) ->
      sinon.spy mocks.dal, 'model'
      model = require(dir + '/models/roles')(mocks.dal)
      done()
    
    afterEach (done) ->
      mocks.dal.model.restore()
      done()

    
    it 'Creates a Role dal model', (done) ->
      expect(mocks.dal.model.calledWith('Role'
      , sinon.match.any)).to.be.true
      done()

    describe 'Schema', ->

      it 'systemId: ObjectId', (done) ->
        expect(mocks.dal.model.calledWith('Role'
        , sinon.match.hasOwn 'systemId', 'ObjectId')).to.be.true
        done()

      it 'name: String', (done) ->
        expect(mocks.dal.model.calledWith('Role'
        , sinon.match.hasOwn 'name', 'String')).to.be.true
        done()

    describe 'Exports',  ->
      mut = require(dir + '/models/roles')(mocks.dal)
      mocks.exportsCrudModel 'Role', mut
