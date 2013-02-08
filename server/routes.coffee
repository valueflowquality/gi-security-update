module.exports = (app, auth, mongoose) ->
  api = require('./controllers/api')(mongoose)
  #user routes
  app.get     '/api/user',        auth.userAction,  api.users.showMe
  app.put     '/api/user',        auth.userAction,  api.users.updateMe
  app.delete  '/api/user',        auth.userAction,  api.users.destroyMe


  # sysAdminAction routes
  app.get     '/api/users',       auth.sysAdminAction,  api.users.index
  app.delete  '/api/users/:id',   auth.sysAdminAction,  api.users.destroy