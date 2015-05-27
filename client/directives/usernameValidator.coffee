angular.module('gi.security').directive 'giUsername'
, ['giUser', '$q', '$parse'
, (User, $q, $parse) ->
  restrict: 'A'
  require: 'ngModel'
  compile: (elem, attrs) ->
    linkFn = ($scope, elem, attrs, controller) ->
      ngModelController = controller

      $viewValue = () ->
        ngModelController.$viewValue

      requiredGetter = $parse attrs.giUsername

      $scope.$watch 'item.register', (newVal) ->
        ngModelController.$$parseAndValidate()

      ngModelController.$asyncValidators.giUsername = (modelValue, viewValue) ->
        deferred = $q.defer()
        if requiredGetter($scope)
          User.isUsernameAvailable(modelValue).then (valid) ->
            if valid
              deferred.resolve()
            else
              deferred.reject()
        else
          deferred.resolve()

        deferred.promise

    linkFn
]
