angular.module('app', ['ngRoute', 'ngResource', 'gi.ui', 'gi.util', 'gi.security']);

angular.module('app').controller('mainController', [
  '$scope', function($scope) {
    return $scope.testText = 'This is the gi-security test-suite';
  }
]);

angular.module('app').config([
  '$locationProvider', function($locationProvider) {
    $locationProvider.html5Mode(true).hashPrefix('!');
  }
]);