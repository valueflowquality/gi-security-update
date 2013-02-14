

console.log('test routes3');

angular.module('app').config([
  '$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
    return $routeProvider.when('/login', {
      controller: 'loginController',
      templateUrl: '/views/gint-security/login.html'
    }).when('/user', {
      controller: 'userController',
      templateUrl: '/views/gint-security/user.html'
    }).when('/logout', {
      controller: 'logoutController',
      templateUrl: '/views/gint-security/logout.html'
    }).when('/role', {
      controller: 'roleController',
      templateUrl: '/views/gint-security/role.html'
    }).when('/users', {
      controller: 'usersController',
      templateUrl: '/views/gint-security/user-management.html'
    });
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
    var all, destroy, factory, get, items, methods, resource, save, updateMasterList;
    methods = {
      query: {
        method: 'GET',
        params: {},
        isArray: true
      },
      save: {
        method: 'PUT',
        params: {},
        isArray: false
      },
      create: {
        method: 'POST',
        params: {},
        isArray: false
      }
    };
    resource = $resource('/api/users/:id', {}, methods);
    items = [];
    updateMasterList = function(item) {
      var replaced;
      replaced = false;
      angular.forEach(items, function(item, index) {
        if (!replaced) {
          if (item._id === item._id) {
            replaced = true;
            return items[index] = item;
          }
        }
      });
      if (!replaced) {
        return items.push(item);
      }
    };
    all = function(callback) {
      if (items.length === 0) {
        return resource.query(function(results) {
          items = results;
          if (callback) {
            return callback(items);
          }
        });
      } else {
        if (callback) {
          return callback(items);
        }
      }
    };
    save = function(item, success) {
      if (item._id) {
        console.log('updating user');
        return resource.save({
          id: item._id
        }, item, function(result) {
          updateMasterList(result);
          if (success) {
            return success();
          }
        });
      } else {
        console.log('creating user');
        return resource.create({}, item, function(result) {
          console.log('got a result ' + result);
          updateMasterList(result);
          if (success) {
            return success();
          }
        });
      }
    };
    get = function(params, callback) {
      return resource.get(params, function(item) {
        updateMasterList(item);
        if (callback) {
          return callback(item);
        }
      });
    };
    destroy = function(id, callback) {
      return resource["delete"]({
        id: id
      }, function() {
        var removed;
        removed = false;
        angular.forEach(items, function(item, index) {
          if (!removed) {
            if (item._id === id) {
              removed = true;
              return items.splice(index, 1);
            }
          }
        });
        if (callback) {
          return callback();
        }
      });
    };
    factory = function() {
      return {
        first_name: '',
        last_name: ''
      };
    };
    return {
      query: all,
      all: all,
      get: get,
      create: factory,
      destroy: destroy,
      save: save
    };
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
    $scope.newUser = User.create();
    $scope.currentView = 'list';
    $scope.getData = function() {
      return User.query(function(results) {
        $scope.users = results;
        return $scope.selectedUser = $scope.users[0];
      });
    };
    $scope.deleteUser = function(id) {
      return User["delete"]({
        id: id
      }, function() {
        return $scope.getData();
      });
    };
    $scope.saveUser = function(user) {
      return User.save(user, function() {
        return $scope.getData;
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
    $scope.selectUser = function(user) {
      return $scope.selectedUser = user;
    };
    $scope.show = function(view) {
      return $scope.currentView = view;
    };
    return $scope.getData();
  }
]);


angular.module('app').factory('Role', [
  '$resource', function($resource) {
    var all, destroy, factory, get, methods, resource, roles, save, updateMasterList;
    methods = {
      query: {
        method: 'GET',
        params: {},
        isArray: true
      },
      save: {
        method: 'PUT',
        params: {},
        isArray: false
      },
      create: {
        method: 'POST',
        params: {},
        isArray: false
      }
    };
    resource = $resource('/api/role/:id', {}, methods);
    roles = [];
    updateMasterList = function(role) {
      var replaced;
      replaced = false;
      angular.forEach(roles, function(item, index) {
        if (!replaced) {
          if (item._id === role._id) {
            replaced = true;
            return roles[index] = role;
          }
        }
      });
      if (!replaced) {
        return roles.push(role);
      }
    };
    all = function(callback) {
      if (roles.length === 0) {
        return resource.query(function(results) {
          roles = results;
          if (callback) {
            return callback(roles);
          }
        });
      } else {
        if (callback) {
          return callback(roles);
        }
      }
    };
    save = function(role, success) {
      if (role._id) {
        console.log('updating role');
        return resource.save({}, role, function(result) {
          updateMasterList(result);
          if (success) {
            return success();
          }
        });
      } else {
        console.log('creating role');
        return resource.create({}, role, function(result) {
          console.log('got a result ' + result);
          updateMasterList(result);
          if (success) {
            return success();
          }
        });
      }
    };
    get = function(params, callback) {
      return resource.get(params, function(role) {
        updateMasterList(role);
        if (callback) {
          return callback(role);
        }
      });
    };
    destroy = function(id, callback) {
      return resource["delete"]({
        id: id
      }, function() {
        var removed;
        removed = false;
        angular.forEach(roles, function(item, index) {
          if (!removed) {
            if (item._id === id) {
              removed = true;
              return roles.splice(index, 1);
            }
          }
        });
        if (callback) {
          return callback();
        }
      });
    };
    factory = function() {
      return {
        name: ''
      };
    };
    return {
      query: all,
      all: all,
      get: get,
      create: factory,
      destroy: destroy,
      save: save
    };
  }
]);


angular.module('app').controller('roleController', [
  '$scope', 'Role', function($scope, Role) {
    $scope.roles = [];
    $scope.newRole = Role.create();
    $scope.saveRole = function(role) {
      console.log('save role clicked');
      return Role.save(role, function() {
        return $scope.getRoles();
      });
    };
    $scope.getRoles = function() {
      return Role.query(function(roles) {
        $scope.roles = roles;
        $scope.selectedRole = roles[0] != null;
        return $scope.show('list');
      });
    };
    $scope.selectRole = function(role) {
      return $scope.selectedRole = role;
    };
    $scope.deleteRole = function(role) {
      return Role.destroy(role._id, function() {
        return $scope.getRoles();
      });
    };
    $scope.show = function(selector) {
      return $scope.currentView = selector;
    };
    $scope.show('list');
    return $scope.getRoles();
  }
]);


angular.module('app').directive('roleform', function() {
  return {
    restrict: 'E',
    templateUrl: '/views/gint-security/role-form.html',
    scope: {
      role: '=',
      submit: '&',
      destroy: '&',
      submitText: '@'
    },
    link: function(scope, elm, attrs) {
      scope.showDelete = true;
      scope.showDeleteModal = false;
      scope.deleteRole = function() {
        scope.destroy({
          role: scope.role
        });
        return scope.showDeleteModal = false;
      };
      return scope.confirmDelete = function() {
        return scope.showDeleteModal = true;
      };
    }
  };
});

var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

angular.module('app').directive('userform', [
  'Role', function(Role) {
    return {
      restrict: 'E',
      templateUrl: '/views/gint-security/user-form.html',
      scope: {
        user: '=',
        submit: '&',
        destroy: '&',
        submitText: '@'
      },
      link: function(scope, elm, attrs) {
        var getRoles, refreshUserRoles;
        scope.showDelete = true;
        scope.showDeleteModal = false;
        scope.userRoles = [];
        scope.notUserRoles = [];
        refreshUserRoles = function() {
          scope.userRoles = [];
          scope.notUserRoles = [];
          return angular.forEach(scope.roles, function(role) {
            var _ref;
            if ((scope.user.roles != null) && (_ref = role._id, __indexOf.call(scope.user.roles, _ref) >= 0)) {
              return scope.userRoles.push(role);
            } else {
              return scope.notUserRoles.push(role);
            }
          });
        };
        getRoles = function() {
          return Role.all(function(roles) {
            scope.roles = roles;
            return refreshUserRoles();
          });
        };
        scope.deleteUser = function() {
          scope.destroy({
            user: scope.user
          });
          return scope.showDeleteModal = false;
        };
        scope.confirmDelete = function() {
          return scope.showDeleteModal = true;
        };
        scope.addToRole = function(role) {
          scope.user.roles.push(role._id);
          return refreshUserRoles();
        };
        scope.removeFromRole = function(role) {
          return angular.forEach(scope.user.roles, function(userRole, index) {
            if (userRole === role._id) {
              scope.user.roles.splice(index, 1);
              return refreshUserRoles();
            }
          });
        };
        return getRoles();
      }
    };
  }
]);

;