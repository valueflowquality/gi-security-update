module.exports = (mongoose) ->
  models = require('../models')(mongoose)
  user = require('./users')(models.users)
  role = require('./role')(models.roles)
  
  user: user
  role: role
