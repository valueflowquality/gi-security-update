index = require './index'
routes = require './routes'
models = require './models'
controllers = require './controllers'
authentication = require './authentication'
describe 'Gint-Security',  ->
  index()
  routes()
  controllers()
  models()
  authentication()