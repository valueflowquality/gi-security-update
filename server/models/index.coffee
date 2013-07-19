module.exports = (mongoose, crudModelFactory) ->
  environments = require('./environments')(mongoose, crudModelFactory)
  
  systems: require('./systems')(mongoose, crudModelFactory)
  environments: environments
  users: require('./users')(mongoose, crudModelFactory)
  roles: require('./roles')(mongoose, crudModelFactory)
  settings: require('./settings')(mongoose, crudModelFactory, environments)
  activities: require('./activities')(mongoose, crudModelFactory)
  categories: require('./categories')(mongoose, crudModelFactory)
  files: require('./files')(mongoose, crudModelFactory)