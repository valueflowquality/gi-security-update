angular.module('app').directive 'roleform', ->
  restrict: 'E'
  templateUrl: '/views/gint-security/role-form.html'
  scope:
    role: '='
    submit: '&'
    destroy: '&'
    submitText: '@'
  link: (scope, elm, attrs) ->

    scope.showDelete = true

    scope.showDeleteModal = false

    scope.deleteRole = ->
      scope.destroy {role: scope.role}
      scope.showDeleteModal = false

    scope.confirmDelete = ->
      scope.showDeleteModal = true