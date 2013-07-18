module.exports = (mongoose, crudModelFactory) ->
  systems: require('./systems')(mongoose, crudModelFactory)
  environments: require('./environments')(mongoose, crudModelFactory)
  users: require('./users')(mongoose, crudModelFactory)
  roles: require('./roles')(mongoose, crudModelFactory)
  settings: require('./settings')(mongoose, crudModelFactory)
  activities: require('./activities')(mongoose, crudModelFactory)
  categories: require('./categories')(mongoose, crudModelFactory)