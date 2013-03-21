require
  shim:
    'controllers/userController':
      deps: [
        'services/user'
      ]
    'controllers/users':
      deps: [
        'services/userAccountService'
      ]
    'controllers/role':
      deps: [
        'services/role'
      ]
  [
    'views'
    'routes'
    'controllers/loginController'
    'controllers/logoutController'
    'controllers/userController'
    'controllers/users'
    'controllers/role'
    'directives/roleForm'
    'directives/userForm'
  ], () ->
    console.log 'gint-security loaded'