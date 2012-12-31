angular.module('app').controller 'usersController'
, ['$scope', 'User'
, ($scope, User) ->
  $scope.max = 10

  $scope.getData = () ->
    $scope.users = User.query {max: $scope.max}
    , () ->
      $scope.max = $scope.users.length

  $scope.deleteUser = (id) ->
    User.delete {id: id}
    , () ->
      $scope.getData()

  $scope.getUsers = () ->
    $scope.users = User.query()

  $scope.deleteUser = (id) ->
    User.delete {id: id}
    , () ->
      $scope.getUsers()

  $scope.getData()
]