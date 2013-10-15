path = require 'path'
expect = require('chai').expect
moment = require 'moment'
mocks = require '../mocks'

dir =  path.normalize __dirname + '../../../../../../server'

module.exports = () ->
  describe 'Activities', ->
    sinon = mocks.sinon
    model = require(dir + '/models/activities')(
      mocks.mongoose, mocks.crudModelFactory
    )

    it 'Creates an Activity mongoose model', (done) ->
      expect(mocks.mongoose.model.calledWith('Activity'
      , sinon.match.any)).to.be.true
      done()

    describe 'Schema', ->

      it 'systemId: ObjectId', (done) ->
        expect(mocks.mongoose.model.calledWith('Activity'
        , sinon.match.hasOwn 'systemId', 'ObjectId')).to.be.true
        done()

      it 'description: String', (done) ->
        expect(mocks.mongoose.model.calledWith('Activity'
        , sinon.match.hasOwn 'description', 'String')).to.be.true
        done()

      it 'from: Mixed', (done) ->
        expect(mocks.mongoose.model.calledWith('Activity'
        , sinon.match.hasOwn 'from', 'Mixed')).to.be.true
        done()

      it 'to: Mixed', (done) ->
        expect(mocks.mongoose.model.calledWith('Activity'
        , sinon.match.hasOwn 'to', 'Mixed')).to.be.true
        done()

      it 'status: ObjectId', (done) ->
        expect(mocks.mongoose.model.calledWith('Activity'
        , sinon.match.hasOwn 'status'
        , {type: 'ObjectId', ref: 'JobStatus'})).to.be.true
        done()

      it 'code: Number', (done) ->
        expect(mocks.mongoose.model.calledWith('Activity'
        , sinon.match.hasOwn 'code', 'Number')).to.be.true
        done()
      
      it 'parent: {key: ObjectId, resourceType: String}', (done) ->
        expect(mocks.mongoose.model.calledWith('Activity'
        , sinon.match.hasOwn 'parent'
        , {key: 'ObjectId', resourceType: 'String'})).to.be.true
        done()
      
      it 'user: {type: ObjectId, ref: User}', (done) ->
        expect(mocks.mongoose.model.calledWith('Activity'
        , sinon.match.hasOwn 'user'
        , {type: 'ObjectId', ref: 'User'})).to.be.true
        
        done()

      it 'job:  {type: ObjectId, ref: Job}', (done) ->
        expect(mocks.mongoose.model.calledWith('Activity'
        , sinon.match.hasOwn 'job'
        , {type: 'ObjectId', ref: 'Job'})).to.be.true
        done()

      it 'timeStamp: Date default Date.now', (done) ->
        expect(mocks.mongoose.model.calledWith('Activity'
        , sinon.match.hasOwn 'job'
        , {type: 'ObjectId', ref: 'Job'})).to.be.true

        now = moment()
        lowerBound = moment().subtract "seconds", 2
        upperBound = moment().add "seconds", 2
        timestamp = moment(mocks.mongoose.model.args[0][1]
        .timeStamp.default())
        expect(timestamp.isBefore upperBound).to.be.true
        expect(timestamp.isAfter lowerBound).to.be.true
        done()

    describe 'Exports',  ->
      mocks.exportsCrudModel 'Activity', model