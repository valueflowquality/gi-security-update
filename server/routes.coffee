module.exports = (app, auth, mongoose) ->
  api = require('./controllers/api')(mongoose)
  #user routes
  app.get     '/api/user',        auth.userAction,  api.users.showMe
  app.put     '/api/user',        auth.userAction,  api.users.updateMe
  app.delete  '/api/user',        auth.userAction,  api.users.destroyMe

  app.get     '/api/role',        auth.userAction,  api.role.index
  app.post    '/api/role',        auth.userAction,  api.role.create
  app.get     '/api/role/:id',    auth.userAction,  api.role.show
  app.put     '/api/role/:id',    auth.userAction,  api.role.update
  app.delete  '/api/role/:id',    auth.userAction,  api.role.destroy
  # sysAdminAction routes
  app.get     '/api/users',       auth.sysAdminAction,  api.users.index
  app.delete  '/api/users/:id',   auth.sysAdminAction,  api.users.destroy