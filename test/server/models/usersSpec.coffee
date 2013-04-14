should = require 'should'
mongoose = require 'mongoose'
_ = require 'underscore'
models = require './models'

dropUsersCollection = () ->
  mongoose.connection.collections['users']?.drop()

describe 'User Model', ->
  user = models.users
  id = ''
  before (done) ->
    dropUsersCollection()
    done()

  it 'Set user firstName', (done) ->
    user.create { firstName: 'toto' }, (err, result) ->
      should.exist result
      result.should.have.property('_id')
      result.should.have.property('firstName', 'toto')
      id = result._id
      done()

  it 'Can find users by Id', (done) ->
    user.findById id, (err, result) ->
      should.exist result
      result.should.have.property('firstName', 'toto')
      done()

  it 'Can find multiple users', (done) ->
    user.find {}, (err, result) ->
      result.length.should.equal 1
      user.create { firstName: 'bob' }, (err, result) ->
        user.find {}, (err, result) ->
          result.length.should.equal 2
          done()

  it 'Can update the first name of an user', (done) ->
    user.findById id, (err, result) ->
      should.not.exist err
      result.firstName = 'barry'
      user.update id, {firstName: 'barry'}, (err, result) ->
        should.not.exist err
        result.should.have.property('firstName', 'barry')
        done()

  it 'Can delete users', (done) ->
    user.destroy id, (err, result) ->
      user.find {}, (err, result) ->
        result.length.should.equal 1
        done()

  it 'Hashes password on creation', (done) ->
    user.create { firstName: 'bob', password: 'aPassword' }, (err, result) ->
      #Check we're doing some sort of hash
      result.password.should.not.equal 'aPassword'
      result.comparePassword 'aPassword', (err, isMatch) ->
        isMatch.should.equal(true)
        result.comparePassword 'aBadPassword', (err, isNotMatch) ->
          isNotMatch.should.equal(false)

          done()

  it 'Does not allow logins with blank passwords', (done) ->
    user.create { firstName: 'bob' }, (err, result) ->
      result.comparePassword '', (err, isMatch) ->
        isMatch.should.be.false
        result.comparePassword undefined, (err, isMatch2) ->
          isMatch2.should.be.false
          result.comparePassword null, (err, isMatch3) ->
            isMatch3.should.be.false
            done()

  it 'Can update a password', (done) ->
    user.create { firstName: 'bob', password: 'aPassword'}, (err, result) ->
      result.comparePassword 'aPassword', (err, isMatch) ->
        isMatch.should.be.true
        user.update result._id
        , {firstName: 'bob', password: 'anotherPassword'}
        , (err, updatedUser) ->
          updatedUser.comparePassword 'anotherPassword', (err, updateMatch) ->
            updateMatch.should.be.true
            done()

