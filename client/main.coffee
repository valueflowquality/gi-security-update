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
    'filters/userName':
      deps: [
        'services/user'
      ]
    'controllers/loginController':
      deps: [
        'services/facebook'
        'services/setting'
      ]
    'services/facebook': deps: ['libs/facebook']
  [
    'libs/facebook'
    'views'
    'routes'
    'filters/userName'
    'controllers/loginController'
    'controllers/logoutController'
    'controllers/userController'
    'controllers/users'
    'controllers/role'
    'directives/roleForm'
    'directives/userForm'
    'services/facebook'
    'services/setting'
  ], () ->
    console.log 'gint-security loaded'