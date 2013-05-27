should = require 'should'
mongoose = require 'mongoose'
models = require './models'

dropRolesCollection = (cb) ->
  mongoose.connection.collections['roles']?.drop () ->
    cb() if cb

describe 'Role Model', ->
  model = models.roles

  before (done) ->
    dropRolesCollection done

  it 'is a Role model', (done) ->
    model.name.should.equal 'Role'
    done()

  it 'Can have a name', (done) ->
    model.create { name: 'toto' }, (err, result) ->
      should.exist result
      result.should.have.property('_id')
      result.should.have.property('name', 'toto')
      done()

  it 'Can find roles by Id', (done) ->
    model.create { name: 'boris'}, (e, res) ->
      model.findById res._id, (err, result) ->
        should.exist result
        result.should.have.property('name', 'boris')
        done()

  it 'Can find multiple roles', (done) ->
    model.find {}, (err, result) ->
      temp = result.length
      model.create { name: 'bob' }, (err, result) ->
        model.find {}, (err, result) ->
          result.length.should.equal temp + 1
          done()

  it 'Can update the name of a role', (done) ->
    model.create { name: 'jack'}, (e, res) ->
      model.findById res._id, (err, result) ->
        should.not.exist err
        result.name = 'barry'
        model.update res._id, {name: 'barry'}, (err, result) ->
          should.not.exist err
          result.should.have.property('name', 'barry')
          done()

  it 'Can be deleted', (done) ->
    model.create {}, (err, res) ->
      model.destroy res._id, (err, result) ->
        model.findById res._id, (err, result) ->
          should.not.exist result
          done()