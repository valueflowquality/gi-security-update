routes = require './routes'
models = require './models'
controllers = require './controllers'
describe 'Gint-Security',  ->
   routes()
   controllers()
   models()