gi = require 'gi-util'
routes = require './routes'
controllers = require './controllers'
authentication = require './authentication'
modelsFactory = require './models'
configure = (app, dal, options) ->

  models = modelsFactory dal
  gi.common.extend app.models, models
  gi.common.extend app.controllers, controllers(app)
  gi.common.extend app.middleware, authentication(app, options)
  
  routes.configure app, gi.common.rest

module.exports =
  configure: configure