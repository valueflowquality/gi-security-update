gint = require 'gint-util'
rest = gint.common.rest

module.exports = (app, auth, api) ->
  #user routes
  app.get     '/api/user',        auth.userAction,  api.user.showMe
  app.put     '/api/user',        auth.userAction,  api.user.updateMe
  app.del     '/api/user',        auth.userAction,  api.user.destroyMe

  rest.routeResource 'roles',      app, auth.userAction, api.role
  # sysAdminAction routes
  rest.routeResource 'users',     app, auth.userAction, api.user
  rest.routeResource 'settings',  app, auth.publicAction, api.setting
  rest.routeResource 'activities', app, auth.userAction, api.activity
  rest.routeResource 'categories', app, auth.userAction, api.category
  rest.routeResource 'systems', app, auth.userAction, api.system
  rest.routeResource 'environments', app, auth.userAction, api.environment