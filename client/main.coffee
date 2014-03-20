require
  shim:
    'controllers/userController':
      deps: [
        'index'
        'services/user'
      ]
    'controllers/users':
      deps: [
        'index'
        'services/userAccount'
        'services/permission'
      ]
    'controllers/role':
      deps: [
        'index'
        'services/role'
      ]
    'controllers/permisssion':
      deps: [
        'index'
        'services/resource'
      ]
    'filters/userName':
      deps: [
        'index'
        'services/user'
      ]
    'controllers/login':
      deps: [
        'index'
        'services/facebook'
        'services/setting'
      ]
    'controllers/logoutController': deps: ['index']
    'services/user': deps: ['index']
    'services/facebook': deps: ['libs/facebook', 'index']
    'interceptors/auth': deps: ['services/auth', 'index']
    'routes': deps: ['index']
    'filters/permissionUser': deps: ['index']
    'filters/premissionRestriction': deps: ['index']
    'directives/auth': deps: ['index']
    'directives/roleForm': deps: ['index']
    'directives/userForm': deps: ['index']
    'directives/permissionForm': deps: ['index']
    'services/auth': deps: ['index']
    'services/setting': deps: ['index']
    'services/permission': deps: ['index']
    'services/resource': deps: ['index']
  [
    'index'
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
    console.log 'gi-security loaded'