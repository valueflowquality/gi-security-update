console.log 'test routes3'
angular.module('app').config ['$routeProvider', '$locationProvider'
, ($routeProvider, $locationProvider) ->
  $routeProvider
  .when '/test'
    controller: 'testController'
    templateUrl: '/views/Angular-Users/test.html'
]