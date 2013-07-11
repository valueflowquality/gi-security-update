module.exports = (mongoose) ->
  users: require('./users')(mongoose)
  roles: require('./roles')(mongoose)
  accounts: require('./accounts')(mongoose)
  settings: require('./settings')(mongoose)
  activities: require('./activities')(mongoose)
  categories: require('./categories')(mongoose)