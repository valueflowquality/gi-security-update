module.exports = (models, gint) ->
  user: require('./users')(models.users)
  role: require('./role')(models.roles)
  setting: gint.controllers.crud(models.settings)
