angular.module('app').directive 'permissionForm'
, ['$q', '$timeout', '$http', 'Resource', 'User', 'Permission'
, ($q, $timeout, $http, Resource, User, Permission) ->
  restrict: 'E'
  templateUrl: '/views/permissionForm.html'
  scope:
    permission: '='
    submit: '&'
    destroy: '&'
    submitText: '@'
  link: (scope, elm, attrs) ->
    scope.resourceTypes = []
    scope.keys = []
    scope.selectedKeys = []
    scope.users = []

    scope.showDelete = true

    scope.showDeleteModal = false

    scope.restrictions = Permission.restrictions

    scope.$watch 'permission', (newVal, oldVal) ->
      if newVal and (not oldVal)
        refreshPermissionFields()
    
    scope.$watch 'selectedResourceType', (newVal, oldVal) ->
      if newVal
        scope.selectedKeys = []
        getRelatedKeys newVal.name
    
    pluralise = (str) ->
      result = str.toLowerCase()
      suffix = 'ory'
      if result.indexOf(suffix, result.length - suffix.length) isnt -1
        result = result.substring(0, result.length - 1) + 'ies'
      else
        result += 's'
      result

    getRelatedKeys = (name) ->
      uri = '/api/' + pluralise(name)
      $http.get(uri).success (data) ->
        scope.keys = data
        angular.forEach scope.keys, (key) ->
          key.id = key._id

    scope.deletePermission = ->
      scope.destroy {permission: scope.permission}
      scope.showDeleteModal = false

    scope.confirmDelete = ->
      scope.showDeleteModal = true
  
    getUsers = ->
      deferred = $q.defer()
      User.all (users) ->
        scope.users = users
        angular.forEach scope.users, (user) ->
          user.id = user._id
        deferred.resolve()
        return
      deferred.promise

    getResources = ->
      deferred = $q.defer()
      Resource.all().then (resources) ->
        scope.resourceTypes = resources
        angular.forEach scope.resourceTypes, (resource) ->
          resource.id = resource._id
        deferred.resolve()
        return
      deferred.promise

    getSelectedResourceType = () ->
      if scope.permission
        if scope.permission.resourceType
          angular.forEach scope.resourceTypes, (resource) ->
            if resource.name is scope.permission.resourceType
              scope.resourceType = resource
    
    getSelectedUser = () ->
      if scope.permission
        if scope.permission.userId
          angular.forEach scope.users, (user) ->
            if user._id is scope.permission.userId
              scope.selectedUser = user
    
    refreshPermissionFields = () ->
      $timeout(getSelectedResourceType)      
      $timeout(getSelectedUser)

    scope.save = () ->
      if scope.permission
        scope.permission.userId = scope.selectedUser._id
        scope.permission.keys = (key._id for key in scope.selectedKeys)
        scope.permission.resourceType = scope.selectedResourceType.name

        scope.submit {permission: scope.permission}

    $q.all([getResources(), getUsers()]).then () ->
      refreshPermissionFields()
]