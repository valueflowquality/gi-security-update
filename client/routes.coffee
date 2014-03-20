angular.module('gi.security').config ['$routeProvider', '$locationProvider'
, ($routeProvider, $locationProvider) ->
  $routeProvider
  .when '/login',
    controller: 'loginController'
    templateUrl: '/views/gi-login.html'
  .when '/user',
    controller: 'userController'
    templateUrl: '/views/gi-user.html'
  .when '/logout',
    controller: 'logoutController'
    templateUrl: '/views/gi-logout.html'
  .when '/roles',
    controller: 'roleController'
    templateUrl: '/views/gi-role.html'
  .when '/users',
    controller: 'usersController'
    templateUrl: '/views/gi-userManagement.html'
  .when '/permissions',
    controller: 'permissionController'
    templateUrl: '/views/gi-permissions.html'
]