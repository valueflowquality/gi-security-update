angular.module('gi.security').directive 'permissionForm'
, ['$q', '$timeout', '$http', '$filter', 'Resource', 'User', 'Permission'
, ($q, $timeout, $http, $filter, Resource, User, Permission) ->
  restrict: 'E'
  templateUrl: '/views/gi-permissionForm.html'
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
      refreshPermissionFields()
    
    scope.$watch 'selectedResourceType', (newVal, oldVal) ->
      if newVal?.name
        scope.selectedKeys = []
        getRelatedKeys newVal.name
    
    pluralise = (str) ->
      if str?
        result = str.toLowerCase()
        suffix = 'y'
        if result.indexOf(suffix, result.length - suffix.length) isnt -1
          result = result.substring(0, result.length - 1) + 'ies'
        else
          result += 's'
        result
      else
        str

    getRelatedKeys = (name) ->
      uri = '/api/' + pluralise(name)
      $http.get(uri).success (data) ->
        scope.selectedKeys = []
        scope.keys = data
        angular.forEach scope.keys, (key) ->
          key.id = key._id
        getSelectedKeys()

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
      scope.selectedResourceType = {}
      if scope.permission
        if scope.permission.resourceType
          angular.forEach scope.resourceTypes, (resource) ->
            if resource.name is scope.permission.resourceType
              scope.selectedResourceType = resource
    
    getSelectedUser = () ->
      scope.selectedUser = {}
      if scope.permission
        if scope.permission.userId
          angular.forEach scope.users, (user) ->
            if user._id is scope.permission.userId
              scope.selectedUser = user

    getSelectedKeys = () ->
      scope.selectedKeys = []
      if scope.permission and scope.permission.keys?
        scope.selectedKeys = $filter('filter')(scope.keys, (key) ->
          scope.permission.keys.indexOf(key._id) isnt -1
        )
    
    refreshPermissionFields = () ->
      $timeout getSelectedResourceType
      $timeout getSelectedUser
      $timeout getSelectedKeys

    scope.save = () ->
      if scope.permission
        scope.permission.userId = scope.selectedUser._id
        scope.permission.keys = (key._id for key in scope.selectedKeys)
        scope.permission.resourceType = scope.selectedResourceType.name

        scope.submit {permission: scope.permission}

    $q.all([getResources(), getUsers()]).then () ->
      refreshPermissionFields()
]