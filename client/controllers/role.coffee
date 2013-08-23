angular.module('app').controller 'roleController'
, ['$scope','$location', 'Role', 'User'
, ($scope, $location, Role, User) ->

  $scope.roles = []
  
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

  if $scope.isAdmin
    User.query (results) ->
      $scope.users = results
      
    $scope.show 'list'
    reset()
  else
    $location.path '/login'
]