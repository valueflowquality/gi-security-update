util = require 'util'
module.exports = (app, mongoose, options) ->
  
  models = require('./models')(mongoose)
  controllers = require('./controllers')(models)
  auth = require('./authentication')(app, models.users, options)
  
  require('./routes')(app, auth, controllers)

  auth