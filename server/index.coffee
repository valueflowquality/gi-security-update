util = require 'util'
module.exports = (app, mongoose, options) ->
  
  models = require('./models')(mongoose)
  controllers = require('./controllers')(models)
  auth = require('./authentication')(app, models, options)
  
  require('./routes')(app, auth, controllers)

  resetTestDb = ->

  app.configure 'test', ->

    resetTestDb = (callback) ->
      console.log 'dropping test accounts'
      mongoose.connection.collections['accounts']?.drop () ->
        console.log 'injecting test account'
        dummyAccount =
          name: 'Acme'
          host: 'localhost'
        
        models.accounts.create dummyAccount, (err, result) ->
          {}

      console.log 'dropping test users'
      mongoose.connection.collections['users']?.drop () ->
        console.log 'injecting test dummy admin user'
        dummyAdmin =
          email: 'dummyadmin@test.com'
          firstName: 'Dummy'
          lastName: 'Admin'
          password: 'password'

        alice =
          email: 'alice@test.com'
          firstName: 'Alice'
          lastName: 'Alison'
          password: 'password'

        models.users.create alice, (err, result) ->
          {}
          models.users.create dummyAdmin, (err, result) ->
            callback(models)

  auth: auth
  resetTestDb: resetTestDb
  models: models
  controllers: controllers