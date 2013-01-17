module.exports = (mongoose) ->
  users = require('./users')(mongoose)
  users: users
