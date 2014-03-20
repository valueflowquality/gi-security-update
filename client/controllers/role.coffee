angular.module('gi.security').controller 'roleController'
, ['$scope','$location', 'Role', 'User', 'Auth'
, ($scope, $location, Role, User, Auth) ->
  $scope.roles = []
  
  reset = () ->
    $scope.newRole = Role.create()
    $scope.getRoles()

  refreshRoleUsers = (role) ->
    $scope.roleUsers = []
    if role?._id?
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
        refreshRoleUsers roles[0]

  $scope.selectRole = (role) ->
    $scope.selectedRole = role
    refreshRoleUsers role

  $scope.deleteRole = (role) ->
    Role.destroy role._id, () ->
      $scope.getRoles()

  $scope.show = (selector) ->
    $scope.currentView = selector

  Auth.isAdmin().then (isAdmin) ->
    if isAdmin
      User.query (results) ->
        $scope.users = results
        refreshRoleUsers($scope.selectedRole)
        
      $scope.show 'list'
      reset()
    else
      console.log 'redirecting to login'
      $location.path '/login'
]