should = require 'should'
mongoose = require 'mongoose'
models = require './models'

dropRolesCollection = () ->
  mongoose.connection.collections['roles']?.drop()

describe 'Role Model', ->
  role = models.roles
  id = ''
  before (done) ->
    dropRolesCollection()
    done()

  it 'Set role name', (done) ->
    role.create { name: 'toto' }, (err, result) ->
      should.exist result
      result.should.have.property('_id')
      result.should.have.property('name', 'toto')
      id = result._id
      done()