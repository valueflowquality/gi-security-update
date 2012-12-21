console.log 'test controller'
angular.module('app').controller 'testController'
, ['$scope'
, ($scope) ->
  console.log 'we got into test controller!'
  $scope.message = 'hello there'
]