console.log 'test routes3'
angular.module('app').config ['$routeProvider', '$locationProvider'
, ($routeProvider, $locationProvider) ->
  $routeProvider
  .when '/login'
    controller: 'loginController'
    templateUrl: '/views/gint-security/login.html'
  .when '/user'
    controller: 'userController'
    templateUrl: '/views/gint-security/user.html'
  .when '/logout'
    controller: 'logoutController'
    templateUrl: '/views/gint-security/logout.html'
  .when '/role'
    controller: 'roleController'
    templateUrl: '/views/gint-security/role.html'
]