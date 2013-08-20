index = require './index'
routes = require './routes'
models = require './models'
controllers = require './controllers'
describe 'Gint-Security',  ->
   index()
   routes()
   controllers()
   models()