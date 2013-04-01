util = require 'util'
module.exports = (app, mongoose, options) ->
  
  models = require('./models')(mongoose)
  controllers = require('./controllers')(models)
  auth = require('./authentication')(app, models, options)
  
  require('./routes')(app, auth, controllers)

  app.configure 'test', ->
    
    console.log 'injecting test account'
    dummyAccount = 
      name: 'Acme'
      host: 'localhost'
    
    models.accounts.create dummyAccount, (err, result) ->
      {}

    console.log 'injecting test dummy admin user'
    dummyAdmin = 
      email: 'dummyadmin@test.com'
      firstName: 'Dummy'
      lastName: 'Admin'
      password: 'password'

    models.users.create dummyAdmin, (err, result) ->
      {}

  auth