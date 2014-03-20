angular.module('gi.security').controller 'permissionController'
, ['$scope', '$location', 'Resource', 'Permission', 'Auth'
, ($scope, $location, Resource, Permission, Auth) ->
  
  Resource.all().then (rts) ->
    console.log 'rts'
    console.log rts
    $scope.resourceTypes = rts
  
  $scope.selectedPermissions = []

  $scope.options =
    customSearch: false
    customSort: false
    searchProperties: ['resourceType']
    searchFilters: ['permissionUser', 'permissionRestriction']
    displayCounts: true
    columns: 3

  $scope.savePermission = (permission) ->
    Permission.save permission

  Auth.isAdmin().then (isAdmin) ->
    if isAdmin
      Permission.all().then (permissions) ->
        $scope.permissions = permissions

      $scope.$watch 'selectedPermissions[0]',  (newVal, oldVal) ->
        if newVal
          $scope.permission = newVal
          $scope.submitText = "Update Permission"
        else
          $scope.permission = {}
          $scope.submitText = "Add Permission"
    else
      $location.path '/login'

]