

console.log('test routes3');

angular.module('app').config([
  '$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
    return $routeProvider.when('/test', {
      controller: 'testController',
      templateUrl: '/views/gint-security/test.html'
    }).when('/login', {
      controller: 'loginController',
      templateUrl: '/views/gint-security/login.html'
    }).when('/user', {
      controller: 'userController',
      templateUrl: '/views/gint-security/user.html'
    }).when('/logout', {
      controller: 'logoutController',
      templateUrl: '/views/gint-security/logout.html'
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


angular.module('app').controller('loginController', [
  '$rootScope', '$scope', '$http', '$timeout', 'authService', function($rootScope, $scope, $http, $timeout, authService) {
    $scope.testLogin = function() {
      return $http.get('/api/loginstatus').success(function(data, status) {
        if (data.loggedIn) {
          $scope.getLoggedInUser();
          return authService.loginConfirmed();
        } else {
          return $timeout($scope.testLogin, 1000);
        }
      }).error(function(data, status) {
        return $timeout($scope.testLogin, 1000);
      });
    };
    return $scope.testLogin();
  }
]);


angular.module('app').controller('logoutController', [
  '$rootScope', '$scope', '$http', '$timeout', 'authService', function($rootScope, $scope, $http, $timeout, authService) {
    return $http.get('/api/logout').success(function() {
      $rootScope.me = {};
      return $rootScope.loggedIn = false;
    });
  }
]);


angular.module('app').factory('User', [
  '$resource', function($resource) {
    return $resource('/api/users/:id', {}, {
      query: {
        method: 'GET',
        parms: {},
        isArray: true
      }
    });
  }
]);


angular.module('app').controller('userController', [
  '$scope', 'UserAccount', function($scope, UserAccount) {
    $scope.deleteUser = function(id) {
      return UserAccount["delete"]();
    };
    $scope.resetApi = function() {
      console.log('reset api');
      return UserAccount.resetApi();
    };
    return $scope.user = UserAccount.get();
  }
]);


angular.module('app').factory('UserAccount', [
  '$resource', function($resource) {
    var methods;
    methods = {
      query: {
        method: 'GET',
        params: {},
        isArray: true
      },
      resetApi: {
        method: 'PUT',
        params: {
          resetApi: true
        }
      }
    };
    return $resource('/api/user', {}, methods);
  }
]);


angular.module('app').controller('usersController', [
  '$scope', 'User', function($scope, User) {
    $scope.max = 10;
    $scope.getData = function() {
      return $scope.users = User.query({
        max: $scope.max
      }, function() {
        return $scope.max = $scope.users.length;
      });
    };
    $scope.deleteUser = function(id) {
      return User["delete"]({
        id: id
      }, function() {
        return $scope.getData();
      });
    };
    $scope.getUsers = function() {
      return $scope.users = User.query();
    };
    $scope.deleteUser = function(id) {
      return User["delete"]({
        id: id
      }, function() {
        return $scope.getUsers();
      });
    };
    return $scope.getData();
  }
]);

;