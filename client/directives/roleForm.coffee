angular.module('gi.security').directive 'roleForm', ->
  restrict: 'E'
  templateUrl: '/views/gi-roleForm.html'
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