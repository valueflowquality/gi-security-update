angular.module('app').controller 'roleController'
, ['$scope', 'Role', 'User'
, ($scope, Role, User) ->

  $scope.roles = []

  $scope.newRole = Role.create()
  
  User.query (results) ->
    $scope.users = results

  refreshRoleUsers = (role) ->
    $scope.roleUsers = []
    angular.forEach $scope.users, (user) ->
      if role._id in user.roles
        $scope.roleUsers.push user

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
    refreshRoleUsers role

  $scope.deleteRole = (role) ->
    Role.destroy role._id, () ->
      $scope.getRoles()

  $scope.show = (selector) ->
    $scope.currentView = selector
  
  $scope.show 'list'
  $scope.getRoles()

]