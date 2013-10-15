path = require 'path'
assert = require('chai').assert
expect = require('chai').expect
moment = require 'moment'
mocks = require '../mocks'

dir =  path.normalize __dirname + '../../../../../../server'

module.exports = () ->
  describe 'Resources', ->

    model = require(dir + '/models/resources')(
      mocks.mongoose, mocks.crudModelFactory
    )

    sinon = mocks.sinon
    
    it 'Creates a Resource mongoose model', (done) ->
      expect(mocks.mongoose.model.calledWith('Resource'
      , sinon.match.any)).to.be.true
      done()

    describe 'Schema', ->

      it 'systemId: ObjectId', (done) ->
        expect(mocks.mongoose.model.calledWith('Resource'
        , sinon.match.hasOwn 'systemId', 'ObjectId')).to.be.true
        done()

      it 'name: String', (done) ->
        expect(mocks.mongoose.model.calledWith('Resource'
        , sinon.match.hasOwn 'name', 'String')).to.be.true
        done()

    describe 'Exports',  ->
      mocks.exportsCrudModel 'Resource', model
