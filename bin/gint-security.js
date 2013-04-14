
angular.module('app').run(['$templateCache', function ($templateCache) {
	$templateCache.put('/views/login.html', '<div class="hero-unit"> <h3>Please Login</h3> <div class="well form-inline"> <input type="text" ng-model="cred.username" class="input" placeholder="Email"> <input type="password" ng-model="cred.password" class="input-small" placeholder="Password"> <button ng-disabled="!cred.username || !cred.password" class="btn btn-primary" ng-click="login()"> Login </button> </div> <div class="well form"> <a href="/auth/facebook" target="_blank"><img src="/img/login-with-facebook.png" width="154" height="22"></a> </div> </div> ');
	$templateCache.put('/views/logout.html', '<div class="hero-unit"> <h3>You have been securely logged out</h3> <a href="/login" class="btn btn-primary">Log Back In</a> </div>');
	$templateCache.put('/views/role-form.html', '<div class="well form"> <input type="hidden" id="hiddenSiteId" ng-model="role._id"/> <div class="control-group"> <label class="control-label">Name:</label> <div class="controls"> <input type="text" name="name" ng-model="role.name"/> </div> </div> <div class="control-group"> <div class="controls"> <button class="btn btn-primary" ng-click="submit({role: role})"> {{submitText}} </button> <button ng-show="showDelete" class="btn btn-danger" ng-click="confirmDelete()"> <i class="icon-white icon-trash"/> </button> </div> </div> </div> <modal visible="showDeleteModal" title="Please Confirm Delete Action"> <div class="body"> <p>Delete a role - are you sure?</p> <p>Please continue only if you are 100% you understand what you\'re deleting. There is no way to retrieve the data after this point.</p> </div> <div class="footer"> <button ng-click="deleteRole()" \ class="btn btn-danger"> Delete It! </button> </div> </modal>');
	$templateCache.put('/views/role.html', '<div class="container-fluid"> <div class="row-fluid"> <div class="span2"> <ul class="nav nav-list"> <li ng-class="{active: currentView==\'list\' }"> <a ng-click="show(\'list\')">All Roles</a> </li> <li ng-class="{active: currentView==\'form\' }"> <a ng-click="show(\'form\')">New Role</a> </li> </ul> </div> <div class="span10"> <div> <div ng-show="selectedRole"> <div class="span6"> <h4>Roles</h4> <ul class="nav nav-list" ng-repeat="role in roles"> <li ng-class="{active: role.name==selectedRole.name}"> <a ng-click="selectRole(role)">{{role.name}}</a> </li> </ul> <div> <h4>Role Members</h4> <div ng-repeat="user in roleUsers">{{user.first_name}}</div> </div> </div> <div ng-show="currentView==\'list\'" class="span6"> <h4>Role Details</h4> <roleform role="selectedRole" title="Role Details" submit-text="Update Role" submit="saveRole(role)" destroy="deleteRole(role)"></roleform> </div> <div ng-show="currentView==\'form\'" class="span6"> <roleform role="newRole" title="Role Details" submit-text="Create Role" submit="saveRole(role)"></roleform> </div> </div> <div ng-hide="selectedRole"> <div class="span6"> <h4>Roles</h4> No Roles found for this organisation. You can create one by entering the details on this page. </div> <div class="span6"> <roleform title="New Role" role="newRole" submit-text="Create Role" submit="saveRole(role)"></roleform> </div> </div> </div> </div> </div> </div>');
	$templateCache.put('/views/test.html', '<div class="container-fluid"> <div class="row-fluid"> <h3>Test Page</h3> <h4>{{message}}</h4> </div> </div>');
	$templateCache.put('/views/user-form.html', '<div class="well form"> <h4>Profile</h4> <div class="control-group"> <label class="control-label">First Name:</label> <div class="controls"> <input type="text" name="name" ng-model="user.firstName" ng-change="checkForChanges()"/> </div> </div> <div class="control-group"> <label class="control-label">Surname:</label> <div class="controls"> <input type="text" name="lastName" ng-model="user.lastName" ng-change="checkForChanges()"/> </div> </div> <div class="control-group"> <label class="control-label">Email:</label> <div class="controls"> <input type="text" name="email" ng-model="user.email" ng-change="checkForChanges()"/> </div> </div> <div class="control-group"> <label class="control-label">Password:</label> <div class="controls"> <input type="password" name="password" ng-model="user.password" ng-change="checkForChanges()"/> </div> </div> <div class="control-group"> <div class="controls"> <button class="btn btn-primary" ng-disabled="!unsavedChanges" ng-click="save()">{{submitText}}</button> </div> </div> </div> <div class="well form"> <h4>Roles</h4> <div class="control-group"> <h4>Assigned Roles</h4> <div class="span12" ng-repeat="role in userRoles"> <label>{{role.name}}<label> <button class="btn btn-danger" ng-click="removeFromRole(role)"> <i class="icon-white icon-trash"/> </button> </div> <h4>Available Roles</h4> <select ng-model="selectedRole" ng-options="role.name for role in notUserRoles"> </select> <div class="controls"> <button ng-click="addToRole(selectedRole)" class="btn btn-primary">Assign</button> </div> </div> <div class="control-group"> <div class="controls"> <button ng-disabled="!unsavedChanges" class="btn btn-primary" ng-click="save()"> {{submitText}} </button> <button ng-show="showDelete" class="btn btn-danger" ng-click="confirmDelete()"> <i class="icon-white icon-trash"/> </button> </div> </div> </div> <modal visible="showDeleteModal" title="Please Confirm Delete Action"> <div class="body"> <p>Delete a user - are you sure?</p> <p>Please continue only if you are 100% you understand what you\'re deleting. There is no way to retrieve the data after this point.</p> </div> <div class="footer"> <button ng-click="deleteUser()" \ class="btn btn-danger"> Delete It! </button> </div> </modal>');
	$templateCache.put('/views/user-management.html', '<div class="container-fluid"> <div class="row-fluid"> <div class="span2"> <ul class="nav nav-list"> <li ng-class="{active: currentView==\'list\' }"> <a ng-click="show(\'list\')">All Users</a> </li> <li ng-class="{active: currentView==\'form\' }"> <a ng-click="show(\'form\')">New User</a> </li> </ul> </div> <div class="span10"> <div> <div ng-show="selectedUser"> <div class="span6"> <h4>Users</h4> <ul class="nav nav-list" ng-repeat="user in users"> <li ng-class="{active: user._id==selectedUser._id}"> <a ng-click="selectUser(user)">{{user.firstName}}</a> </li> </ul> </div> <div ng-show="currentView==\'list\'" class="span6"> <userform user="selectedUser" title="User Details" submit-text="Save Changes" submit="saveUser(user)" destroy="deleteUser(user)"></userform> </div> <div ng-show="currentView==\'form\'" class="span6"> <userform title="New User" user="newUser" submit-text="Create User" submit="saveUser(user)"></userform> </div> </div> <div ng-hide="selectedUser"> <div class="span6"> <h4>Users</h4> No Users found for this organisation. You can create one by entering the details on this page. </div> <div class="span6"> <h4>Create New User</h4> <userform title="New User" user="newUser" submit-text="Create User" submit="saveUser(user)"></userform> </div> </div> </div> </div> </div> </div>');
	$templateCache.put('/views/user.html', '<label name="userName">Name: {{user.firstName}} {{ user.lastName }}</label> <label name="userId">Id: {{user._id}}</label> <label name="apiSecret">API Secret: {{user.apiSecret}}</label> <button class="btn btn-primary" ng-click="resetApi()">Create API Secret</button>');
}]);

angular.module('app').config([
  '$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
    return $routeProvider.when('/login', {
      controller: 'loginController',
      templateUrl: '/views/login.html'
    }).when('/user', {
      controller: 'userController',
      templateUrl: '/views/user.html'
    }).when('/logout', {
      controller: 'logoutController',
      templateUrl: '/views/logout.html'
    }).when('/role', {
      controller: 'roleController',
      templateUrl: '/views/role.html'
    }).when('/users', {
      controller: 'usersController',
      templateUrl: '/views/user-management.html'
    });
  }
]);


angular.module('app').factory('User', [
  '$resource', function($resource) {
    var all, destroy, factory, get, getByIdSync, items, itemsById, methods, resource, save, updateMasterList;
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
    itemsById = {};
    updateMasterList = function(newItem) {
      var replaced;
      replaced = false;
      angular.forEach(items, function(item, index) {
        if (!replaced) {
          if (newItem._id === item._id) {
            replaced = true;
            return items[index] = newItem;
          }
        }
      });
      if (!replaced) {
        items.push(newItem);
      }
      itemsById[newItem._id] = newItem;
    };
    all = function(callback) {
      if (items.length === 0) {
        return resource.query(function(results) {
          items = results;
          angular.forEach(results, function(item, index) {
            itemsById[item._id] = item;
          });
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
        return resource.save({
          id: item._id
        }, item, function(result) {
          updateMasterList(result);
          if (success) {
            return success();
          }
        });
      } else {
        return resource.create({}, item, function(result) {
          updateMasterList(result);
          if (success) {
            return success();
          }
        });
      }
    };
    getByIdSync = function(id) {
      return itemsById[id];
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
        delete itemsById[id];
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
        firstName: '',
        lastName: '',
        roles: []
      };
    };
    return {
      query: all,
      all: all,
      get: get,
      getSync: getByIdSync,
      create: factory,
      destroy: destroy,
      save: save
    };
  }
]);


angular.module('app').filter('userName', [
  'User', function(User) {
    return function(id) {
      var result, user;
      result = 'Missing User Id';
      if (id) {
        user = User.getSync(id);
        if (user) {
          result = user.firstName;
        } else {
          result = id;
        }
      }
      return result;
    };
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
    $scope.login = function() {
      return $http.post('/api/login', $scope.cred);
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
  '$resource', '$rootScope', '$http', function($resource, $rootScope, $http) {
    var getMe, methods, resource;
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
    resource = $resource('/api/user', {}, methods);
    getMe = function(callback) {
      if ($rootScope.me != null) {
        return callback($rootScope.me);
      } else {
        return $http.get('/api/user').success(function(user) {
          if (callback) {
            return callback(user);
          }
        });
      }
    };
    return {
      get: resource.get,
      getMe: getMe
    };
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

var __indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

angular.module('app').controller('roleController', [
  '$scope', 'Role', 'User', function($scope, Role, User) {
    var refreshRoleUsers, reset;
    $scope.roles = [];
    User.query(function(results) {
      return $scope.users = results;
    });
    reset = function() {
      $scope.newRole = Role.create();
      return $scope.getRoles();
    };
    refreshRoleUsers = function(role) {
      $scope.roleUsers = [];
      return angular.forEach($scope.users, function(user) {
        var _ref;
        if (_ref = role._id, __indexOf.call(user.roles, _ref) >= 0) {
          return $scope.roleUsers.push(user);
        }
      });
    };
    $scope.saveRole = function(role, callback) {
      return Role.save(role, function() {
        reset();
        if (callback) {
          return callback();
        }
      });
    };
    $scope.getRoles = function() {
      return Role.query(function(roles) {
        $scope.roles = roles;
        if (roles.length > 0) {
          return $scope.selectedRole = roles[0];
        }
      });
    };
    $scope.selectRole = function(role) {
      $scope.selectedRole = role;
      return refreshRoleUsers(role);
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
    return reset();
  }
]);


angular.module('app').directive('roleform', function() {
  return {
    restrict: 'E',
    templateUrl: '/views/role-form.html',
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
      templateUrl: '/views/user-form.html',
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
        scope.unsavedChanges = false;
        scope.$watch('user', function(newVal) {
          if (newVal) {
            scope.unsavedChanges = false;
            return refreshUserRoles();
          }
        });
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
        scope.checkForChanges = function() {
          return scope.unsavedChanges = true;
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
          scope.unsavedChanges = true;
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
        scope.save = function() {
          scope.unsavedChanges = false;
          return scope.submit({
            user: scope.user
          });
        };
        return getRoles();
      }
    };
  }
]);

;