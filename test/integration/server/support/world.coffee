supertest = require 'supertest'
app = require '../../../../example/server/app'

class World
  constructor: (callback) ->
    # set up code goes here
    @request = supertest(app)
    @req = null
    @res = null

    # last line to tell cucumber.js the World is ready.
    callback @

exports.World = World