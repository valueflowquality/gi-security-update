gint = require 'gint-util'
routes = require './routes'

configure = (app, mongoose, options) ->
  
  models = require('./models')(mongoose, gint.common.crudModelFactory)

  gint.common.extend app.models, models
  gint.common.extend app.controllers, require('./controllers')(app)
  gint.common.extend app.middleware, require('./authentication')(app, options)

  gint.common.registerResourceTypes mongoose, models
  
  routes.configure app, gint.common.rest

module.exports =
  configure: configure