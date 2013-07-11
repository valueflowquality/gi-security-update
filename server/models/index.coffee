module.exports = (mongoose) ->
  systems: require('./systems')(mongoose)
  environments: require('./environments')(mongoose)
  users: require('./users')(mongoose)
  roles: require('./roles')(mongoose)
  settings: require('./settings')(mongoose)
  activities: require('./activities')(mongoose)
  categories: require('./categories')(mongoose)