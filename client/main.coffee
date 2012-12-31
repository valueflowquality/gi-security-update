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
  [
    'routes'
    'controllers/testController'
    'controllers/loginController'
    'controllers/logoutController'
    'controllers/userController'
    'controllers/usersController'
  ], () ->
    console.log 'Angular-Users loaded'