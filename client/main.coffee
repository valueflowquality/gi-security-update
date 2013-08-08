require
  shim:
    'controllers/userController':
      deps: [
        'services/user'
      ]
    'controllers/users':
      deps: [
        'services/userAccount'
        'services/permission'
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
    'services/permission'
  ], () ->
    console.log 'gint-security loaded'