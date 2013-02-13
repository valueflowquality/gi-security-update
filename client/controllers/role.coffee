angular.module('app').controller 'roleController'
, ['$scope', 'Role'
, ($scope, Role) ->

  $scope.roles = []

  $scope.newRole = Role.create()

  $scope.saveRole = (role) ->
    console.log 'save role clicked'
    Role.save role, () ->
      $scope.getRoles()

  $scope.getRoles = () ->
    Role.query (roles) ->
      $scope.roles = roles
      $scope.selectedRole = roles[0]?
      $scope.show 'list'

  $scope.selectRole = (role) ->
    $scope.selectedRole = role

  $scope.deleteRole = (role) ->
    Role.destroy role._id, () ->
      $scope.getRoles()

  $scope.show = (selector) ->
    $scope.currentView = selector
  
  $scope.show 'list'
  $scope.getRoles()

]