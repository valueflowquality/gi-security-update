should = require 'should'
expect = require('chai').expect
mongoose = require 'mongoose'

models = require './models'

describe 'Models Index', ->

  it 'exports activities model', (done) ->
    should.exist models.activities
    should.exist models.activities.name
    models.activities.name.should.equal 'Activity'
    done()