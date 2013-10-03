express = require 'express'
gint = require 'gint-util'
security = require '../../server'

MongoStore = require('connect-mongo')(express)
mongoose = require 'mongoose'

path = require 'path'
dir =  path.normalize __dirname + "/../client"

console.log dir

app = express()

testConf =
  db:
    host: 'localhost'
    port: '27017'
    name: 'wssTest'
  security:
    strategies: ['Hmac', 'Basic']
    sessionSecret: 'testSecret'

app.configure ->
  gint.common.mongo mongoose, testConf.db
  app.use express.cookieParser()
  app.use express.bodyParser()

  sessionOpts =
    store: new MongoStore({db: testConf.db.name})
    secret: testConf.security.sessionSecret

  app.use express.session(sessionOpts)
  
  #configure all of the security settings
  
  app.models = {}
  app.controllers = {}
  app.middleware = {}

  #configure the module
  security.configure app, mongoose, testConf.security

  app.use express.errorHandler({ dumpExceptions: true, showStack: true })

  console.log 'step1'

  app.get '*', app.middleware.publicAction, (req, res) ->
    res.sendfile "#{dir}/index.html"

exports = module.exports = app