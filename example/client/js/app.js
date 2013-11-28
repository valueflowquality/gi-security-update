angular.module('app', ['ngRoute', 'ngResource', 'gint.ui', 'gint.util']);

angular.module('app').controller('mainController', [
  '$scope', function($scope) {
    return $scope.testText = 'This is the gint-security test-suite';
  }
]);

angular.module('app').config([
  '$locationProvider', function($locationProvider) {
    $locationProvider.html5Mode(true).hashPrefix('!');
  }
]);