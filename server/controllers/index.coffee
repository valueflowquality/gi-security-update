module.exports = (app) ->
  user:     require('./user')(app.models.users, app.controllers.crud)
  activity: require('./activity')(app.models.activities, app.controllers.crud)
  role:     app.controllers.crud(app.models.roles)
  setting:  app.controllers.crud(app.models.settings)
  category: app.controllers.crud(app.models.categories)
  system: app.controllers.crud(app.models.systems)
  environment: app.controllers.crud(app.models.environments)