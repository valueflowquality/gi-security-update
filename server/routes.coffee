gint = require 'gint-util'
rest = gint.common.rest

configure = (app) ->
  #user routes
  app.get '/api/user'
  , app.middleware.userAction, app.controllers.user.showMe
  
  app.put '/api/user'
  , app.middleware.userAction, app.controllers.user.updateMe
  
  app.del '/api/user'
  , app.middleware.userAction, app.controllers.user.destroyMe

  rest.routeResource 'roles', app
  , app.middleware.userAction, app.controllers.role
  # sysAdminAction routes
  
  rest.routeResource 'users', app
  , app.middleware.userAction, app.controllers.user
  
  rest.routeResource 'settings', app
  , app.middleware.userAction, app.controllers.setting
  
  rest.routeResource 'activities', app
  , app.middleware.userAction, app.controllers.activity
  
  rest.routeResource 'categories', app
  , app.middleware.userAction, app.controllers.category
  
  rest.routeResource 'systems', app
  , app.middleware.userAction, app.controllers.system
  
  rest.routeResource 'environments', app
  , app.middleware.userAction, app.controllers.environment

  rest.routeResource 'files', app
  , app.middleware.userAction, app.controllers.file

exports.configure = configure