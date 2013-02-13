should = require 'should'
mongoose = require 'mongoose'

models = require './models'

dropUsersCollection = () ->
  mongoose.connection.collections['users']?.drop()

describe 'User Model', ->
  user = models.users
  id = ''
  before (done) ->
    dropUsersCollection()
    done()

  it 'Set user first_name', (done) ->
    user.create { first_name: 'toto' }, (err, result) ->
      should.exist result
      result.should.have.property('_id')
      result.should.have.property('first_name', 'toto')
      id = result._id
      done()

  it 'Can find users by Id', (done) ->
    user.findById id, (err, result) ->
      should.exist result
      result.should.have.property('first_name', 'toto')
      done()

  it 'Can find multiple users', (done) ->
    user.find {}, (err, result) ->
      result.length.should.equal 1
      user.create { first_name: 'bob' }, (err, result) ->
        user.find {}, (err, result) ->
          result.length.should.equal 2
          done()

  it 'Can update the first name of an user', (done) ->
    user.findById id, (err, result) ->
      if err
        console.log err
      result.first_name = 'barry'
      user.update id, {first_name: 'barry'}, (err, result) ->
        if err
          console.log err
        result.should.have.property('first_name', 'barry')
        done()

  it 'Can delete users', (done) ->
    user.destroy id, (err, result) ->
      user.find {}, (err, result) ->
        result.length.should.equal 1
        done()