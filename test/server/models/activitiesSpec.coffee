should = require 'should'
mongoose = require 'mongoose'
moment = require 'moment'
models = require './models'

dropCollection = () ->
  mongoose.connection.collections['activities']?.drop()

describe 'Activities Model', ->
  model = models.activities
  before (done) ->
    dropCollection()
    done()
  it 'Is an activities model', (done) ->
    model.name.should.equal 'Activity'
    done()
    
  it 'Can have a description', (done) ->
    model.create { description: 'toto' }, (err, result) ->
      should.exist result
      result.should.have.property('_id')
      result.should.have.property('description', 'toto')
      id = result._id
      done()

  it 'Can have a from field', (done) ->
    model.create { from: 'toto' }, (err, result) ->
      should.exist result
      result.should.have.property('_id')
      result.should.have.property('from', 'toto')
      id = result._id
      done()

  it 'Can have a to field', (done) ->
    model.create { to: 'toto' }, (err, result) ->
      should.exist result
      result.should.have.property('_id')
      result.should.have.property('to', 'toto')
      id = result._id
      done()

  it 'Can be found', (done) ->
    model.find {}, (err, res) ->
      model.create { description: 'bob' }, (err, result) ->
        model.find {}, (err, result) ->
          result.length.should.equal res.length + 1
          done()

  it 'Has a timeStamp defaulting to now', (done) ->
    now = moment()
    lowerBound = moment().subtract "seconds", 2
    upperBound = moment().add "seconds", 2
    model.create {}, (err, result) ->
      should.exist result
      result.should.have.property 'timeStamp'
      timestamp = moment(result.timeStamp)
      (timestamp.isBefore upperBound).should.be.true
      (timestamp.isAfter lowerBound).should.be.true
      done()

  it 'Can have a user', (done) ->
    userId = mongoose.Types.ObjectId('4edd40c86762e0fb12000002')
    model.create { user: userId }, (err, result) ->
      result.should.have.property('user', userId )
      done()

  it 'Can have a job', (done) ->
    jobId = mongoose.Types.ObjectId('4edd40c86762e0fb12000002')
    model.create { job: jobId }, (err, result) ->
      result.should.have.property('job', jobId )
      done()
  
  it 'Can have a status', (done) ->
    statusId = mongoose.Types.ObjectId('4edd40c86762e0fb12000002')
    model.create { status: statusId }, (err, result) ->
      result.should.have.property('status', statusId )
      done()
  
  it 'Can have a code', (done) ->
    code = 102
    model.create { code: code }, (err, result) ->
      result.should.have.property('code', code)
      done()

  it 'Can be found by id', (done) ->
    model.create {description: 'toto'}, (err, res) ->
      model.findById res._id, (err, result) ->
        should.exist result
        result.should.have.property('description', 'toto')
        done()

  it 'Can find one by field', (done) ->
    code = 102
    model.create { code: code }, (err, result) ->
      model.findOneBy 'code', code, (err, res) ->
        should.not.exist err
        should.exist res
        res.should.have.property 'code', code
        done()

  it 'Can be updated', (done) ->
    model.create { description : 'bob' }, (e, res) ->
      model.findById res._id, (err, result) ->
        should.not.exist err
        result.description = 'barry'
        model.update res._id, {description: 'barry'}, (err, result) ->
          should.not.exist err
          result.should.have.property('description', 'barry')
          done()

  it 'Can be deleted', (done) ->
    model.create {}, (err, res) ->
      model.destroy res._id, (err, result) ->
        model.findById res._id, (err, result) ->
          should.not.exist result
          done()