angular.module('gi.security').directive 'giRolePicker'
, [ '$filter'
, ($filter) ->
  restrict: 'E'
  scope:
    model: '='
  templateUrl: '/views/giRolePicker.html'
  link:
    pre: ($scope) ->
      $scope.my = {}

      refresh = () ->
        $scope.model.chosenItems = []
        $scope.model.availableItems = []

        angular.forEach $scope.model.roles, (role) ->
          found = false
          angular.forEach $scope.model.chosen, (memberId) ->
            if memberId.toString() is role._id.toString()
              found = true
          if found
            $scope.model.chosenItems.push role
          else
            $scope.model.availableItems.push role

      $scope.$watch 'model.roles', (newVal, oldVal) ->
        if newVal?
          refresh()

      $scope.$watch 'model.item', (newVal, oldVal) ->
        if newVal? and newVal._id isnt oldVal?._id
          refresh()


]
