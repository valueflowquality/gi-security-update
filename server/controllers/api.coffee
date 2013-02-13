module.exports = (mongoose) ->
  models = require('../models/models')(mongoose)
  users = require('./users')(models)
  role = require('./role')(models.roles)
  
  users: users
  role: role
