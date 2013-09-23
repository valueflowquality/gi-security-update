supertest = require 'supertest'
app = require '../../app'
mongo = require 'mongodb'

class World
  constructor: (callback) ->
    # set up code goes here
    @request = supertest(app)

    # last line to tell cucumber.js the World is ready.
    callback @

exports.World = World