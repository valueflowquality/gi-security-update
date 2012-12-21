

console.log('test routes3');

angular.module('app').config([
  '$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
    return $routeProvider.when('/test', {
      controller: 'testController',
      templateUrl: '/views/Angular-Users/test.html'
    });
  }
]);


console.log('test controller');

angular.module('app').controller('testController', [
  '$scope', function($scope) {
    console.log('we got into test controller!');
    return $scope.message = 'hello there';
  }
]);

;