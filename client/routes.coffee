angular.module('gint.security').config ['$routeProvider', '$locationProvider'
, ($routeProvider, $locationProvider) ->
  $routeProvider
  .when '/login',
    controller: 'loginController'
    templateUrl: '/views/login.html'
  .when '/user',
    controller: 'userController'
    templateUrl: '/views/user.html'
  .when '/logout',
    controller: 'logoutController'
    templateUrl: '/views/logout.html'
  .when '/roles',
    controller: 'roleController'
    templateUrl: '/views/role.html'
  .when '/users',
    controller: 'usersController'
    templateUrl: '/views/userManagement.html'
  .when '/permissions',
    controller: 'permissionController'
    templateUrl: '/views/permissions.html'
]