
should = require 'should'
mongoose = require 'mongoose'
models = require './models'

dropAccountsCollection = () ->
  mongoose.connection.collections['accounts']?.drop()

describe 'Account Model', ->
  model = models.accounts
  id = ''
  before (done) ->
    dropAccountsCollection()
    done()
  
  it 'Is an account model', (done) ->
    model.name.should.equal 'Account'
    done()

  it 'Can have a name', (done) ->
    model.create { name: 'toto' }, (err, result) ->
      should.exist result
      result.should.have.property('_id')
      result.should.have.property('name', 'toto')
      id = result._id
      done()

  it 'Can find account by Id', (done) ->
    model.findById id, (err, result) ->
      should.exist result
      result.should.have.property('name', 'toto')
      done()

  it 'Can find multiple accounts', (done) ->
    model.find {}, (err, result) ->
      result.length.should.equal 1
      model.create { name: 'bob' }, (err, result) ->
        model.find {}, (err, result) ->
          result.length.should.equal 2
          done()
  
  it 'Can update the name of an account', (done) ->
    model.findById id, (err, result) ->
      if err
        console.log err
      result.name = 'barry'
      model.update id, {name: 'barry'}, (err, result) ->
        if err
          console.log err
        result.should.have.property('name', 'barry')
        done()

  it 'Can delete accounts', (done) ->
    model.destroy id, (err, result) ->
      model.find {}, (err, result) ->
        result.length.should.equal 1
        done()

  it 'Can have a host', (done) ->
    model.create { host: 'toto'}, (err, result) ->
      should.exist result
      result.should.have.property('host','toto')
      done()

