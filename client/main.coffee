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
    'controllers/permisssion':
      deps: [
        'services/resource'
      ]
    'filters/userName':
      deps: [
        'services/user'
      ]
    'controllers/login':
      deps: [
        'services/facebook'
        'services/setting'
      ]
    'services/facebook': deps: ['libs/facebook']
    'interceptors/auth': deps: ['services/auth']
  [
    'libs/facebook'
    'views'
    'routes'
    'filters/userName'
    'filters/permissionUser'
    'filters/permissionRestriction'
    'controllers/login'
    'controllers/logoutController'
    'controllers/userController'
    'controllers/users'
    'controllers/role'
    'controllers/permission'
    'directives/auth'
    'directives/roleForm'
    'directives/userForm'
    'directives/permissionForm'
    'interceptors/auth'
    'services/auth'
    'services/facebook'
    'services/setting'
    'services/permission'
    'services/resource'
  ], () ->
    console.log 'gint-security loaded'