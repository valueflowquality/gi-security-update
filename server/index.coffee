gint = require 'gint-util'
routes = require './routes'
controllers = require './controllers'
authentication = require './authentication'
modelsFactory = require './models'
configure = (app, dal, options) ->

  models = modelsFactory dal
  gint.common.extend app.models, models
  gint.common.extend app.controllers, controllers(app)
  gint.common.extend app.middleware, authentication(app, options)
  
  routes.configure app, gint.common.rest

module.exports =
  configure: configure