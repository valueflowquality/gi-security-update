angular.module('gi.security').directive 'giUsername'
, ['giUser', '$q'
, (User, $q) ->
  restrict: 'A'
  require: 'ngModel'
  compile: (elem, attrs) ->
    linkFn = ($scope, elem, attrs, controller) ->
      ngModelController = controller

      $viewValue = () ->
        ngModelController.$viewValue

      ngModelController.$asyncValidators.giUsername = (modelValue, viewValue) ->
        deferred = $q.defer()
        User.isUsernameAvailable(modelValue).then (valid) ->
          if valid
            deferred.resolve()
          else
            deferred.reject()
        deferred.promise

    linkFn
]
