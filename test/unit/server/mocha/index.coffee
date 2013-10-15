proxyquire = require 'proxyquire'
path = require 'path'
sinon = require 'sinon'
expect = require('chai').expect

module.exports = ->

  describe 'Exports', ->
    stubs = null
    module = null

    beforeEach (done) ->
      dir =  path.normalize __dirname + '../../../../../server'

      stubs =
        './routes': sinon.stub().returns { configure : -> }
        'gint-util': sinon.stub().returns {common: {extend: ->}}

      module = proxyquire dir, stubs

      done()

    it 'configure: function(app, mongoose, options) -> void', (done) ->
      expect(module).to.have.property 'configure'
      done()