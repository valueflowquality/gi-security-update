require
  shim:
    'controllers/userController':
      deps: [
        'services/userService'
      ]
    'controllers/usersController':
      deps: [
        'services/userAccountService'
      ]
    'controllers/role':
      deps: [
        'services/role'
      ]
  [
    'routes'
    'controllers/loginController'
    'controllers/logoutController'
    'controllers/userController'
    'controllers/usersController'
    'controllers/role'
    'directives/roleForm'
  ], () ->
    console.log 'gint-security loaded'