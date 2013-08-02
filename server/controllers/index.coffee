user = require './user'
activity = require './activity'
file = require './file'

module.exports = (app) ->
  user:         user app.models.users, app.controllers.crud
  activity:     activity app.models.activities, app.controllers.crud
  file:         file app.models, app.controllers.crud
  role:         app.controllers.crud app.models.roles
  setting:      app.controllers.crud app.models.settings
  category:     app.controllers.crud app.models.categories
  system:       app.controllers.crud app.models.systems
  environment:  app.controllers.crud app.models.environments