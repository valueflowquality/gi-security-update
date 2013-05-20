gint = require 'gint-util'
rest = gint.common.rest

module.exports = (app, auth, api) ->
  #user routes
  app.get     '/api/user',        auth.userAction,  api.user.showMe
  app.put     '/api/user',        auth.userAction,  api.user.updateMe
  app.delete  '/api/user',        auth.userAction,  api.user.destroyMe

  rest.routeResource 'role',      app, auth.userAction, api.role
  # sysAdminAction routes
  rest.routeResource 'users',     app, auth.userAction, api.user
  rest.routeResource 'settings',  app, auth.publicAction, api.setting