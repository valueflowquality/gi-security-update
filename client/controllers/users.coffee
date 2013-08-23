angular.module('app').controller 'usersController'
, ['$scope', '$location', 'User'
, ($scope, $location, User) ->

  $scope.newUser = User.create()
  $scope.currentView = 'list'

  $scope.getData = () ->
    User.query (results) ->
      $scope.users = results
      $scope.selectedUser = $scope.users[0]

  $scope.deleteUser = (id) ->
    User.delete {id: id}
    , () ->
      $scope.getData()

  $scope.saveUser = (user) ->
    User.save user, () ->
      $scope.getData()
    
  $scope.getUsers = () ->
    $scope.users = User.query()

  $scope.deleteUser = (id) ->
    User.delete {id: id}
    , () ->
      $scope.getUsers()

  $scope.selectUser = (user) ->
    $scope.selectedUser = user

  $scope.show = (view) ->
    $scope.currentView = view

  if $scope.isAdmin
    $scope.getData()
  else
    $location.path '/login'

]