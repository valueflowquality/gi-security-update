module.exports = (mongoose) ->
  console.log 'in models -> models'
  require('./mongoose/users')(mongoose)
  users: require('./users')(mongoose)