module.exports = (models, gint) ->
  user:     require('./users')(models.users)
  role:     require('./role')(models.roles)
  activity: require('./activity')(models.activities)
  setting:  gint.controllers.crud(models.settings)
  category: gint.controllers.crud(models.categories)
  system: gint.controllers.crud(models.systems)
  environment: gint.controllers.crud(models.environments)