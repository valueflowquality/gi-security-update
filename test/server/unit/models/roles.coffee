path = require 'path'
assert = require('chai').assert
expect = require('chai').expect
moment = require 'moment'
mocks = require '../mocks'

dir =  path.normalize __dirname + '../../../../../server'

module.exports = () ->
  describe 'Roles', ->

    model = require(dir + '/models/roles')(
      mocks.mongoose, mocks.crudModelFactory
    )
    sinon = mocks.sinon
    
    it 'Creates a Role mongoose model', (done) ->
      expect(mocks.mongoose.model.calledWith('Role'
      , sinon.match.any)).to.be.true
      done()

    describe 'Schema', ->

      it 'systemId: ObjectId', (done) ->
        expect(mocks.mongoose.model.calledWith('Role'
        , sinon.match.hasOwn 'systemId', 'ObjectId')).to.be.true
        done()

      it 'name: String', (done) ->
        expect(mocks.mongoose.model.calledWith('Role'
        , sinon.match.hasOwn 'name', 'String')).to.be.true
        done()

    describe 'Exports',  ->
      mocks.exportsCrudModel 'Role', model
