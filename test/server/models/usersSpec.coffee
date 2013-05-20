should = require 'should'
mongoose = require 'mongoose'
_ = require 'underscore'
models = require './models'

dropUsersCollection = () ->
  mongoose.connection.collections['users']?.drop()

describe 'User Model', ->
  model = models.users
  before (done) ->
    dropUsersCollection()
    done()

  it 'Set user firstName', (done) ->
    model.create { firstName: 'toto' }, (err, result) ->
      should.exist result
      result.should.have.property('_id')
      result.should.have.property('firstName', 'toto')
      id = result._id
      done()

  it 'Can find users by Id', (done) ->
    model.create {}, (e, res) ->
      model.findById res._id, (err, result) ->
        should.exist result
        done()

  it 'Can find multiple users', (done) ->
    model.find {}, (err, result) ->
      temp = result.length
      model.create { firstName: 'bob' }, (err, result) ->
        model.find {}, (err, result) ->
          result.length.should.equal temp + 1
          done()

  it 'Can update the first name of an user', (done) ->
    model.create {}, (e, res) ->
      model.findById res._id, (err, result) ->
        should.not.exist err
        result.firstName = 'barry'
        model.update res._id, {firstName: 'barry'}, (err, result) ->
          should.not.exist err
          result.should.have.property('firstName', 'barry')
          done()

  it 'Can be deleted', (done) ->
    model.create {}, (err, res) ->
      model.destroy res._id, (err, result) ->
        model.findById res._id, (err, result) ->
          should.not.exist result
          done()

  it 'Hashes password on creation', (done) ->
    model.create { firstName: 'bob', password: 'aPassword' }, (err, result) ->
      #Check we're doing some sort of hash
      result.password.should.not.equal 'aPassword'
      result.comparePassword 'aPassword', (err, isMatch) ->
        isMatch.should.equal(true)
        result.comparePassword 'aBadPassword', (err, isNotMatch) ->
          isNotMatch.should.equal(false)

          done()

  it 'Does not allow logins with blank passwords', (done) ->
    model.create { firstName: 'bob' }, (err, result) ->
      result.comparePassword '', (err, isMatch) ->
        isMatch.should.be.false
        result.comparePassword undefined, (err, isMatch2) ->
          isMatch2.should.be.false
          result.comparePassword null, (err, isMatch3) ->
            isMatch3.should.be.false
            done()

  it 'Can update a password', (done) ->
    model.create { firstName: 'bob', password: 'aPassword'}, (err, result) ->
      result.comparePassword 'aPassword', (err, isMatch) ->
        isMatch.should.be.true
        model.update result._id
        , {firstName: 'bob', password: 'anotherPassword'}
        , (err, updatedUser) ->
          updatedUser.comparePassword 'anotherPassword', (err, updateMatch) ->
            updateMatch.should.be.true
            done()

