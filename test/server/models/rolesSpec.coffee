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
  it 'is a Role model', (done) ->
    role.name.should.equal 'Role'
    done()

  it 'Can have a name', (done) ->
    role.create { name: 'toto' }, (err, result) ->
      should.exist result
      result.should.have.property('_id')
      result.should.have.property('name', 'toto')
      id = result._id
      done()

  it 'Can find roles by Id', (done) ->
    role.findById id, (err, result) ->
      should.exist result
      result.should.have.property('name', 'toto')
      done()

  it 'Can find multiple roles', (done) ->
    role.find {}, (err, result) ->
      result.length.should.equal 1
      role.create { name: 'bob' }, (err, result) ->
        role.find {}, (err, result) ->
          result.length.should.equal 2
          done()

  it 'Can update the name of a role', (done) ->
    role.findById id, (err, result) ->
      if err
        console.log err
      result.name = 'barry'
      role.update id, {name: 'barry'}, (err, result) ->
        if err
          console.log err
        result.should.have.property('name', 'barry')
        done()

  it 'Can delete roles', (done) ->
    role.destroy id, (err, result) ->
      role.find {}, (err, result) ->
        result.length.should.equal 1
        done()