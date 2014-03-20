angular.module('gi.security').directive 'userForm'
, ['Role'
, (Role) ->
  restrict: 'E'
  templateUrl: '/views/gi-userForm.html'
  scope:
    user: '='
    submit: '&'
    destroy: '&'
    submitText: '@'
  link: (scope, elm, attrs) ->

    scope.showDelete = true

    scope.showDeleteModal = false
    scope.userRoles = []
    scope.notUserRoles = []
    scope.unsavedChanges = false
    

    scope.$watch 'user', (newVal) ->
      if newVal
        scope.unsavedChanges = false
        refreshUserRoles()

    refreshUserRoles = () ->
      scope.userRoles = []
      scope.notUserRoles = []
      angular.forEach scope.roles, (role) ->
        if scope.user?.roles? and role._id in scope.user.roles
          scope.userRoles.push role
        else
          scope.notUserRoles.push role

    getRoles = () ->
      Role.all (roles) ->
        scope.roles = roles
        refreshUserRoles()

    scope.checkForChanges = () ->
      scope.unsavedChanges = true

    scope.deleteUser = ->
      scope.destroy {user: scope.user}
      scope.showDeleteModal = false

    scope.confirmDelete = ->
      scope.showDeleteModal = true

    scope.addToRole = (role) ->
      scope.unsavedChanges = true
      scope.user.roles.push role._id
      refreshUserRoles()

    scope.removeFromRole = (role) ->
      scope.unsavedChanges = true
      angular.forEach scope.user.roles, (userRole, index) ->
        if userRole is role._id
          scope.user.roles.splice index, 1
          refreshUserRoles()

    scope.save = () ->
      scope.unsavedChanges = false
      scope.submit {user: scope.user}

    getRoles()
]