module.exports = (app, auth, api) ->
  #user routes
  app.get     '/api/user',        auth.userAction,  api.user.showMe
  app.put     '/api/user',        auth.userAction,  api.user.updateMe
  app.delete  '/api/user',        auth.userAction,  api.user.destroyMe

  app.get     '/api/role',        auth.userAction,  api.role.index
  app.post    '/api/role',        auth.userAction,  api.role.create
  app.get     '/api/role/:id',    auth.userAction,  api.role.show
  app.put     '/api/role/:id',    auth.userAction,  api.role.update
  app.delete  '/api/role/:id',    auth.userAction,  api.role.destroy
  
  # sysAdminAction routes
  app.get     '/api/users',       auth.sysAdminAction,  api.user.index
  app.post    '/api/users/',      auth.sysAdminAction,  api.user.create
  app.get     '/api/users/:id',   auth.sysAdminAction,  api.user.show
  app.put     '/api/users/:id',   auth.sysAdminAction,  api.user.update
  app.delete  '/api/users/:id',   auth.sysAdminAction,  api.user.destroy
