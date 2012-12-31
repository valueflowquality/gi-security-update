angular.module('app').controller 'userController'
, ['$scope', 'UserAccount'
, ($scope, UserAccount) ->

  $scope.deleteUser = (id) ->
    UserAccount.delete()

  $scope.resetApi = () ->
    console.log 'reset api'
    UserAccount.resetApi()

  $scope.user = UserAccount.get()
]