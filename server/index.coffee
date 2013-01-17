util = require 'util'
module.exports = (app, mongoose, options) ->
  auth = require('./authentication')(app, mongoose, options)
  require('./routes')(app, auth, mongoose)
  auth