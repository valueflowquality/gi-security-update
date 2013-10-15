angular.module('app').controller 'logoutController'
, [ '$rootScope', '$scope', '$http', '$timeout'
, ($rootScope, $scope, $http, $timeout) ->
  #when we're in this controller we should keep testing to see
  #if the user has managed to login yet.
  $http.get('/api/logout')
  .success ->
    $rootScope.me = {}
    $rootScope.loggedIn = false
    $rootScope.isAdmin = false
    $rootScope.isRestricted = false
]