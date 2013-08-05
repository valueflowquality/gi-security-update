path = require 'path'
sinon = require 'sinon'
should = require('chai').should()
assert = require('chai').assert
moment = require 'moment'
mocks = require '../mocks'

dir =  path.normalize __dirname + '../../../../server'

describe 'Activities Model', ->

  model = require(dir + '/models/activities')(mocks.mongoose, mocks.crudModelFactory)

  it 'Creates an Activity mongoose model', (done) ->
    mocks.mongoose.model.calledWith('Activity'
    , sinon.match.any).should.be.true
    done()

  describe 'Schema', ->

    it 'systemId: ObjectId', (done) ->
      mocks.mongoose.model.calledWith('Activity'
      , sinon.match.hasOwn 'systemId', 'ObjectId').should.be.true
      done()

    it 'description: String', (done) ->
      mocks.mongoose.model.calledWith('Activity'
      , sinon.match.hasOwn 'description', 'String').should.be.true
      done()

    it 'from: Mixed', (done) ->
      mocks.mongoose.model.calledWith('Activity'
      , sinon.match.hasOwn 'from', 'Mixed').should.be.true
      done()

    it 'Has a to field', (done) ->
      mocks.mongoose.model.calledWith('Activity'
      , sinon.match.hasOwn 'to', 'Mixed').should.be.true
      done()

    it 'Has a status', (done) ->
      mocks.mongoose.model.calledWith('Activity', sinon.match.hasOwn 'status'
      , {type: 'ObjectId', ref: 'JobStatus'}).should.be.true
      done()

    it 'Has a code', (done) ->
      mocks.mongoose.model.calledWith('Activity'
      , sinon.match.hasOwn 'code', 'Number').should.be.true
      done()
    
    it 'Has a parent', (done) ->
      mocks.mongoose.model.calledWith('Activity', sinon.match.hasOwn 'parent'
      , {key: 'ObjectId', resourceType: 'String'}).should.be.true
      done()
    
    it 'References a user', (done) ->
      mocks.mongoose.model.calledWith('Activity', sinon.match.hasOwn 'user'
      , {type: 'ObjectId', ref: 'User'}).should.be.true
      
      done()

    it 'References a job', (done) ->
      assert mocks.mongoose.model.calledWith('Activity'
      , sinon.match.hasOwn 'job', {type: 'ObjectId', ref: 'Job'})
      done()

    it 'Has a timeStamp defaulting to Date.now', (done) ->
      assert mocks.mongoose.model.calledWith('Activity'
      , sinon.match.hasOwn 'job', {type: 'ObjectId', ref: 'Job'})

      now = moment()
      lowerBound = moment().subtract "seconds", 2
      upperBound = moment().add "seconds", 2
      timestamp = moment(mocks.mongoose.model.args[0][1].timeStamp.default())
      (timestamp.isBefore upperBound).should.be.true
      (timestamp.isAfter lowerBound).should.be.true
      done()   

  describe 'Exports',  ->
     mocks.exportsCrudModel 'Activity', model