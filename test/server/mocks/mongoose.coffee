sinon = require 'sinon'

module.exports =
  model: sinon.stub().withArgs(sinon.match.string).returnsArg 0
