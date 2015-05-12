angular.module('gi.security').directive 'giPassword'
, ['giUser'
, (User) ->
  restrict: 'A'
  require: 'ngModel'
  compile: (elem, attrs) ->

    linkFn = ($scope, elem, attrs, controller) ->
      ngModelController = controller

      $viewValue = () ->
        ngModelController.$viewValue

      ngModelController.$validators.giPassword = (x) ->
        User.testPassword x

    #return the linking function
    linkFn
]
