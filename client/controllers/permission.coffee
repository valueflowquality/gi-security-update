angular.module('app').controller 'permissionController'
, ['$scope', '$location', 'Resource', 'Permission'
, ($scope, $location, Resource, Permission) ->
  
  $scope.resourceTypes = Resource.all()
  
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

  if $scope.isAdmin
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