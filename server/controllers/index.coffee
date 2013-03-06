module.exports = (models) ->
  user = require('./users')(models.users)
  role = require('./role')(models.roles)
  
  user: user
  role: role
