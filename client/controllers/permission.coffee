angular.module('app').controller 'permissionController'
, ['$scope', 'Resource', 'Permission'
, ($scope, Resource, Permission) ->
  
  $scope.resourceTypes = Resource.all()
  $scope.submitText = "Add Permission"
  
  $scope.selectedPermissions = []

  $scope.options =
    customSearch: false
    customSort: false
    searchProperties: ['resourceType']
    searchFilters: []
    displayCounts: true
    columns: 3

  $scope.savePermission = (permission) ->
    Permission.save permission

  Permission.all().then (permissions) ->
    $scope.permissions = permissions
]