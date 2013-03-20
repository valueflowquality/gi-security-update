angular.module('app').controller 'roleController'
, ['$scope', 'Role', 'User'
, ($scope, Role, User) ->

  $scope.roles = []
 
  User.query (results) ->
    $scope.users = results
  
  reset = () ->
    $scope.newRole = Role.create()
    $scope.getRoles()

  refreshRoleUsers = (role) ->
    $scope.roleUsers = []
    angular.forEach $scope.users, (user) ->
      if role._id in user.roles
        $scope.roleUsers.push user

  $scope.saveRole = (role, callback) ->
    Role.save role, () ->
      reset()
      callback() if callback

  $scope.getRoles = () ->
    Role.query (roles) ->
      $scope.roles = roles
      if roles.length > 0
        $scope.selectedRole = roles[0]

  $scope.selectRole = (role) ->
    $scope.selectedRole = role
    refreshRoleUsers role

  $scope.deleteRole = (role) ->
    Role.destroy role._id, () ->
      $scope.getRoles()

  $scope.show = (selector) ->
    $scope.currentView = selector
  
  $scope.show 'list'
  reset()

]