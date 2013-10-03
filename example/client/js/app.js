angular.module('app', ['ngRoute']);

angular.module('app').controller('mainController', [
  '$scope', function($scope) {
    return $scope.testText = 'This is the landing home page for gint-security example';
  }
]);