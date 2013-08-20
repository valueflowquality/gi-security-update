angular.module('app').controller 'userController'
, ['$scope', 'UserAccount'
, ($scope, UserAccount) ->

  $scope.deleteUser = (id) ->
    UserAccount.delete()

  $scope.resetApi = () ->
    UserAccount.resetAPISecret().then () ->
      $scope.user = UserAccount.get()

  $scope.user = UserAccount.get()
]