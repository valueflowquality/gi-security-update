angular.module('gi.security', ['ngResource', 'gi.util', 'gi.ui']);

angular.module('gi.security').config([
  '$routeProvider', '$locationProvider', function($routeProvider, $locationProvider) {
    return $routeProvider.when('/login', {
      controller: 'loginController',
      templateUrl: '/views/gi-login.html'
    }).when('/user', {
      controller: 'userController',
      templateUrl: '/views/gi-user.html'
    }).when('/logout', {
      controller: 'logoutController',
      templateUrl: '/views/gi-logout.html'
    }).when('/roles', {
      controller: 'roleController',
      templateUrl: '/views/gi-role.html'
    }).when('/users', {
      controller: 'usersController',
      templateUrl: '/views/gi-userManagement.html'
    }).when('/permissions', {
      controller: 'permissionController',
      templateUrl: '/views/gi-permissions.html'
    });
  }
]);

angular.module('gi.security').controller('loginController', [
  '$scope', '$http', '$filter', 'Auth', 'Facebook', 'Setting', function($scope, $http, $filter, Auth, Facebook, Setting) {
    $scope.loginStatus = {
      failed: false
    };
    $scope.login = function() {
      return $http.post('/api/login', $scope.cred).success(function() {
        return Auth.loginConfirmed();
      }).error(function() {
        return $scope.loginStatus.failed = true;
      });
    };
    $scope.loginWithFacebook = function() {
      return Facebook.login().then(function(loggedIn) {
        if (loggedIn) {
          return Auth.loginConfirmed();
        }
      });
    };
    $scope.dismissLoginAlert = function() {
      return $scope.loginStatus.failed = false;
    };
    return Setting.all().then(function(settings) {
      var allowFacebookLogin, appId;
      allowFacebookLogin = $filter('filter')(settings, function(setting) {
        return setting.key === 'loginWithFacebook';
      });
      if ((allowFacebookLogin != null ? allowFacebookLogin.length : void 0) > 0) {
        $scope.allowFacebookLogin = allowFacebookLogin[0].value;
      } else {
        $scope.allowFacebookLogin = false;
      }
      if ($scope.allowFacebookLogin) {
        appId = $filter('filter')(settings, function(setting) {
          return setting.key === 'facebookAppId';
        });
        if ((appId != null ? appId.length : void 0) > 0) {
          return Facebook.init(appId[0].value);
        } else {
          return console.log('error initializing facebook login');
        }
      }
    });
  }
]);

angular.module('gi.security').controller('logoutController', [
  'Auth', function(Auth) {
    return Auth.logout();
  }
]);

angular.module('gi.security').controller('permissionController', [
  '$scope', '$location', 'Resource', 'Permission', 'Auth', function($scope, $location, Resource, Permission, Auth) {
    Resource.all().then(function(rts) {
      console.log('rts');
      console.log(rts);
      return $scope.resourceTypes = rts;
    });
    $scope.selectedPermissions = [];
    $scope.options = {
      customSearch: false,
      customSort: false,
      searchProperties: ['resourceType'],
      searchFilters: ['permissionUser', 'permissionRestriction'],
      displayCounts: true,
      columns: 3
    };
    $scope.savePermission = function(permission) {
      return Permission.save(permission);
    };
    return Auth.isAdmin().then(function(isAdmin) {
      if (isAdmin) {
        Permission.all().then(function(permissions) {
          return $scope.permissions = permissions;
        });
        return $scope.$watch('selectedPermissions[0]', function(newVal, oldVal) {
          if (newVal) {
            $scope.permission = newVal;
            return $scope.submitText = "Update Permission";
          } else {
            $scope.permission = {};
            return $scope.submitText = "Add Permission";
          }
        });
      } else {
        return $location.path('/login');
      }
    });
  }
]);

var indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

angular.module('gi.security').controller('roleController', [
  '$scope', '$location', 'Role', 'User', 'Auth', function($scope, $location, Role, User, Auth) {
    var refreshRoleUsers, reset;
    $scope.roles = [];
    reset = function() {
      $scope.newRole = Role.create();
      return $scope.getRoles();
    };
    refreshRoleUsers = function(role) {
      $scope.roleUsers = [];
      if ((role != null ? role._id : void 0) != null) {
        return angular.forEach($scope.users, function(user) {
          var ref;
          if (ref = role._id, indexOf.call(user.roles, ref) >= 0) {
            return $scope.roleUsers.push(user);
          }
        });
      }
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
          $scope.selectedRole = roles[0];
          return refreshRoleUsers(roles[0]);
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
    return Auth.isAdmin().then(function(isAdmin) {
      if (isAdmin) {
        User.query(function(results) {
          $scope.users = results;
          return refreshRoleUsers($scope.selectedRole);
        });
        $scope.show('list');
        return reset();
      } else {
        console.log('redirecting to login');
        return $location.path('/login');
      }
    });
  }
]);

angular.module('gi.security').controller('userController', [
  '$scope', 'UserAccount', function($scope, UserAccount) {
    $scope.deleteUser = function(id) {
      return UserAccount["delete"]();
    };
    $scope.resetApi = function() {
      return UserAccount.resetAPISecret().then(function() {
        return $scope.user = UserAccount.get();
      });
    };
    return $scope.user = UserAccount.get();
  }
]);

angular.module('gi.security').controller('usersController', [
  '$scope', '$location', 'giUser', 'Auth', function($scope, $location, User, Auth) {
    $scope.newUser = {};
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
    $scope.selectUser = function(user) {
      return $scope.selectedUser = user;
    };
    $scope.show = function(view) {
      return $scope.currentView = view;
    };
    return Auth.isAdmin().then(function(isAdmin) {
      if (isAdmin) {
        return $scope.getData();
      } else {
        return Auth.isReadOnlyAdmin().then(function(isReadOnlyAdmin) {
          if (isReadOnlyAdmin) {
            return $scope.getData();
          } else {
            return $location.path('/login');
          }
        });
      }
    });
  }
]);

angular.module('gi.security').filter('permissionRestriction', [
  'Permission', function(Permission) {
    return function(permission) {
      var result;
      result = "N/A";
      if (permission && permission.restriction) {
        angular.forEach(Permission.restrictions, function(res) {
          if (res.value === permission.restriction) {
            return result = res.name;
          }
        });
      }
      return result;
    };
  }
]);

angular.module('gi.security').filter('permissionUser', [
  '$filter', function($filter) {
    return function(permission) {
      var result;
      result = 'Unknown';
      if (permission && permission.userId) {
        result = $filter('userName')(permission.userId);
      }
      return result;
    };
  }
]);

angular.module("gi.security").run(["$templateCache", function($templateCache) {$templateCache.put("gi-login.html","<div class=\"hero-unit\">\r\n  <div class=\"alert alert-danger\" ng-if=\"loginStatus.failed\">\r\n    <button type=\"button\" \r\n            class=\"close dismissLogin\" \r\n            ng-click=\"dismissLoginAlert()\">&times;</button>\r\n    <strong>Login Failed!</strong>: Username / Password was incorrect\r\n  </div>\r\n  <h3>Please Login</h3>\r\n  <div  class=\"well form-inline\">\r\n    <input  type=\"text\" \r\n            ng-model=\"cred.username\" \r\n            class=\"input\" \r\n            placeholder=\"Email\">\r\n    <input  type=\"password\" \r\n            ng-model=\"cred.password\" \r\n            class=\"input-small\" \r\n            placeholder=\"Password\">\r\n    <button ng-disabled=\"!cred.username || !cred.password\" \r\n            class=\"btn btn-primary basicLogin\" \r\n            ng-click=\"login()\">Login</button>\r\n  </div>\r\n  <div class=\"well form loginWithFacebook\" ng-if=\"allowFacebookLogin\">\r\n    <button ng-click=\"loginWithFacebook()\"><img src=\"/img/login-with-facebook.png\" width=\"154\" height=\"22\"></button> \r\n  </div>\r\n</div>");
$templateCache.put("gi-logout.html","<div class=\"hero-unit\">\r\n  <h3>You have been securely logged out</h3>\r\n  <a href=\"/login\" class=\"btn btn-primary\">Log Back In</a>\r\n</div>");
$templateCache.put("gi-permissionForm.html","<div class=\"well form\">\r\n  <div class=\"form-group\"\r\n    <label>User:</label>\r\n    <gi-select2 options=\"users\" selection=\"selectedUser\" field=\"firstName\" style=\"width:100%\"/>\r\n  </div>\r\n  <div class=\"form-group\">\r\n    <label>Resource Type:</label>\r\n    <gi-select2 options=\"resourceTypes\" selection=\"selectedResourceType\" field=\"name\" style=\"width:100%\"/>\r\n  </div>\r\n  <div class=\"form-group\">\r\n    <label>Restriction:</label>\r\n    <select class=\"form-control\" \r\n            ng-model=\"permission.restriction\" \r\n            ng-options=\"r.value as r.name for r in restrictions\"></select>\r\n  </div>\r\n  <div class=\"form-group\">\r\n    <label>{{permission.resourceType.name}}</label>\r\n    <label>Keys:</label>\r\n    <gi-select2 tags custom options=\"keys\" selection=\"selectedKeys\" field=\"name\" style=\"width:100%\"/>\r\n  </div>\r\n  <button class=\"btn btn-primary\" ng-click=\"save()\">\r\n    {{submitText}}\r\n  </button>\r\n  <button ng-show=\"showDelete\" class=\"btn btn-danger\" ng-click=\"confirmDelete()\" >\r\n    <span class=\"glyphicon glyphicon-trash white\"></span>\r\n  </button>\r\n\r\n</div>\r\n<gi-modal visible=\"showDeleteModal\"\r\n        title=\"Please Confirm Delete Action\">\r\n  <div class=\"body\">\r\n    <p>Delete this permission - are you sure?</p>\r\n    <p>Please continue only if you are 100% \r\n      you understand what you\'re deleting.  \r\n      There is no way to retrieve the data after this point.</p>\r\n  </div>\r\n  <div class=\"footer\">\r\n    <button ng-click=\"deletePermission()\"\r\n            class=\"btn btn-danger\">\r\n      Delete It!\r\n    </button>\r\n  </div>\r\n</gi-modal>");
$templateCache.put("gi-permissions.html","<div class=\"container\">\r\n  <div class=\"row\">\r\n    <div class=\"col-md-6\">\r\n      <gi-datatable items=\"permissions\" \r\n                 selected-items=\"selectedPermissions\"\r\n                 options=\"options\" >\r\n        <div class=\"header\">\r\n          <label>User</label>\r\n          <label>Resource</label>\r\n          <label>Restriction</label>\r\n        </div>\r\n        <div class=\"body\">\r\n          <label class=\"filter\">permissionUser</label>\r\n          <label class=\"property\">resourceType</label>\r\n          <label class=\"filter\">permissionRestriction</label>\r\n        </div>\r\n      </gi-datatable>\r\n    </div>\r\n    <div class=\"col-md-6\">\r\n      <permission-form permission=\"permission\" submit-text=\"{{submitText}}\" submit=\"savePermission(permission)\"></permission-form>\r\n    </div>\r\n  </div>\r\n</div>");
$templateCache.put("gi-role.html","<div class=\"container\">\r\n  <div class=\"row\">\r\n    <div class=\"col-md-2\">\r\n      <ul class=\"nav nav-pills nav-stacked\">\r\n        <li ng-class=\"{active: currentView == \'list\' }\">\r\n          <a ng-click=\"show(\'list\')\">All Roles</a>\r\n        </li>\r\n        <li ng-class=\"{active: currentView == \'form\' }\">\r\n          <a ng-click=\"show(\'form\')\">New Role</a>\r\n        </li>\r\n      </ul>\r\n    </div>\r\n    <div class=\"col-md-10\">\r\n      <div>\r\n        <div ng-show=\"selectedRole\" >\r\n          <div class=\"col-md-6\">\r\n            <h4>Roles</h4>\r\n            <ul class=\"nav nav-pills nav-stacked\" ng-repeat=\"role in roles\" >\r\n              <li ng-class=\"{active: role.name == selectedRole.name}\" >\r\n                <a \r\n                 ng-click=\"selectRole(role)\">{{role.name}}</a>\r\n              </li>\r\n            </ul>\r\n            <div>\r\n              <h4>Role Members</h4>\r\n              <div ng-repeat=\"user in roleUsers\">{{user.firstName}}</div>\r\n            </div>\r\n          </div>\r\n          <div ng-show=\"currentView == \'list\'\" class=\"col-md-6\">\r\n            <h4>Role Details</h4>\r\n            <role-form role=\"selectedRole\" title=\"Role Details\" submit-text=\"Update Role\" submit=\"saveRole(role)\" destroy=\"deleteRole(role)\"></role-form>\r\n\r\n          </div>\r\n          <div ng-show=\"currentView == \'form\'\" class=\"col-md-6\">\r\n            <role-form role=\"newRole\" title=\"Role Details\" submit-text=\"Create Role\" submit=\"saveRole(role)\"></role-form>\r\n          </div>\r\n        </div>      \r\n        <div ng-hide=\"selectedRole\">\r\n          <div class=\"col-md-6\">\r\n            <h4>Roles</h4>\r\n            No Roles found for this organisation.\r\n            You can create one by entering the details on this page.\r\n          </div>\r\n          <div class=\"col-md-6\">\r\n            <role-form title=\"New Role\" role=\"newRole\" submit-text=\"Create Role\" submit=\"saveRole(role)\"></role-form>\r\n          </div>\r\n        </div>\r\n      </div>\r\n    </div>\r\n  </div>\r\n</div>");
$templateCache.put("gi-roleForm.html","<div class=\"well form\" role=\"form\">\r\n  <input type=\"hidden\" id=\"hiddenSiteId\" ng-model=\"role._id\"/>\r\n  <div class=\"form-group\">\r\n    <label  >Name:</label>\r\n    <input  type=\"text\" class=\"form-control\" \r\n            name=\"name\" ng-model=\"role.name\"/>\r\n  </div>\r\n  <button class=\"btn btn-primary\" \r\n            ng-click=\"submit({role: role})\">\r\n      {{submitText}}\r\n  </button>\r\n  <button ng-show=\"showDelete\" \r\n          class=\"btn btn-danger\" \r\n          ng-click=\"confirmDelete()\" >\r\n    <span class=\"glyphicon glyphicon-trash white\"></span>\r\n  </button>\r\n</div>\r\n<gi-modal visible=\"showDeleteModal\"\r\n        title=\"Please Confirm Delete Action\">\r\n  <div class=\"body\">\r\n    <p>Delete a role - are you sure?</p>\r\n    <p>Please continue only if you are 100% \r\n      you understand what you\'re deleting.  \r\n      There is no way to retrieve the data after this point.</p>\r\n  </div>\r\n  <div class=\"footer\">\r\n    <button ng-click=\"deleteRole()\"\r\n            class=\"btn btn-danger\">\r\n      Delete It!\r\n    </button>\r\n  </div>\r\n</gi-modal>");
$templateCache.put("gi-rolePicker.html","<div class=\"row\">\r\n  <div id=\"board\">\r\n    <div id=\"columns\" >\r\n      <div class=\"column col-md-6\">\r\n        <div class=\"columnHeader\">\r\n          <span>Available</span>\r\n        </div>\r\n        <ul class=\"cards card-list\" as-sortable\r\n        ng-model=\"model.availableItems\">\r\n          <li as-sortable-item class=\"card\"\r\n          ng-repeat=\"item in model.availableItems\">\r\n            <div as-sortable-item-handle>{{item.name}}</div>\r\n          </li>\r\n        </ul>\r\n      </div>\r\n      <div class=\"column col-md-6\">\r\n        <div class=\"columnHeader\">\r\n          <span>Selected</span>\r\n        </div>\r\n        <ul class=\"cards card-list\" as-sortable=\"dragControlListeners\"\r\n        ng-model=\"model.chosenItems\">\r\n          <li as-sortable-item class=\"card\"\r\n          ng-repeat=\"item in model.chosenItems\">\r\n            <div as-sortable-item-handle>{{item.name}}</div>\r\n          </li>\r\n        </ul>\r\n      </div>\r\n    </div>\r\n  </div>\r\n</div>\r\n");
$templateCache.put("gi-user.html","<div class=\"form\" role=\"form\">\r\n  <div class=\"form-group\">\r\n    <label name=\"userName\">Name: {{user.firstName}} {{ user.lastName }}</label>\r\n  </div>\r\n  <div class=\"form-group\">\r\n    <label name=\"userId\">Id: {{user._id}}</label>\r\n  </div>\r\n  <div class=\"form-group\">\r\n    <label name=\"apiSecret\">API Secret: {{user.apiSecret}}</label>\r\n  </div>\r\n  <div class=\"form-group\">\r\n    <button class=\"btn btn-primary\" ng-click=\"resetApi()\">Create API Secret</button>\r\n  </div>\r\n</div>");
$templateCache.put("gi-userForm.html","<div class=\"well form\">\r\n  <h4>Profile</h4>\r\n  <div class=\"form-group\">\r\n    <label>First Name:</label>\r\n    <input  type=\"text\" name=\"name\" class=\"form-control\" \r\n            ng-model=\"user.firstName\" ng-change=\"checkForChanges()\"/>\r\n  </div>\r\n  <div class=\"form-group\">\r\n    <label>Surname:</label>\r\n    <input  type=\"text\" name=\"lastName\" class=\"form-control\" \r\n            ng-model=\"user.lastName\" ng-change=\"checkForChanges()\"/>\r\n  </div>\r\n  <div class=\"form-group\">\r\n    <label>Email:</label>\r\n    <input  type=\"text\" name=\"email\" class=\"form-control\" \r\n            ng-model=\"user.email\" ng-change=\"checkForChanges()\" />\r\n  </div>\r\n  <div class=\"form-group\">\r\n    <label>Password:</label>\r\n    <input  type=\"password\" name=\"password\" class=\"form-control\" \r\n            ng-model=\"user.password\" ng-change=\"checkForChanges()\" />\r\n  </div>\r\n  <h4>Roles</h4>\r\n  <div class=\"form-group\">\r\n    <h4>Assigned Roles</h4>\r\n    <div class=\"col-md-12\" ng-repeat=\"role in userRoles\">\r\n      <label>{{role.name}}</label>\r\n      <button class=\"btn btn-danger\"\r\n              ng-click=\"removeFromRole(role)\" >\r\n        <span class=\"glyphicon glyphicon-trash white\"></span>\r\n      </button>\r\n    </div>\r\n    <div ng-if=\"notUserRoles.length > 0\">\r\n      <h4>Available Roles</h4>\r\n      <select class=\"form-control\"\r\n              ng-model=\"selectedRole\" \r\n              ng-options=\"role.name for role in notUserRoles\">\r\n      </select>\r\n      <button ng-click=\"addToRole(selectedRole)\" \r\n              class=\"btn btn-primary\">Assign</button>\r\n    </div>\r\n  </div>\r\n  <div class=\"form-group\">\r\n    <button ng-disabled=\"!unsavedChanges\" \r\n            class=\"btn btn-primary\" \r\n            ng-click=\"save()\">\r\n        {{submitText}}\r\n    </button>\r\n    <button ng-show=\"showDelete\" \r\n            class=\"btn btn-danger\" \r\n            ng-click=\"confirmDelete()\" >\r\n      <span class=\"glyphicon glyphicon-trash white\"></span>\r\n    </button>\r\n  </div>\r\n</div>\r\n\r\n<gi-modal visible=\"showDeleteModal\"\r\n        title=\"Please Confirm Delete Action\">\r\n  <div class=\"body\">\r\n    <p>Delete a user - are you sure?</p>\r\n    <p>Please continue only if you are 100% \r\n      you understand what you\'re deleting.  \r\n      There is no way to retrieve the data after this point.</p>\r\n  </div>\r\n  <div class=\"footer\">\r\n    <button ng-click=\"deleteUser()\" \\\r\n            class=\"btn btn-danger\">\r\n      Delete It!\r\n    </button>\r\n  </div>\r\n</gi-modal>");
$templateCache.put("gi-userManagement.html","<div class=\"container\">\r\n  <div class=\"row\">\r\n    <div class=\"col-md-2\">\r\n      <ul class=\"nav nav-pills nav-stacked\">\r\n        <li ng-class=\"{active: currentView == \'list\' }\">\r\n          <a ng-click=\"show(\'list\')\">All Users</a>\r\n        </li>\r\n        <li ng-class=\"{active: currentView == \'form\' }\">\r\n          <a ng-click=\"show(\'form\')\">New User</a>\r\n        </li>\r\n      </ul>\r\n    </div>\r\n    <div class=\"col-md-10\">\r\n      <div>\r\n        <div ng-show=\"selectedUser\" >\r\n          <div class=\"col-md-4\">\r\n            <h4>Users</h4>\r\n            <ul class=\"nav nav-pills nav-stacked\" ng-repeat=\"user in users\" >\r\n              <li ng-class=\"{active: user._id == selectedUser._id}\" >\r\n                <a \r\n                 ng-click=\"selectUser(user)\">{{user.firstName}}</a>\r\n              </li>\r\n            </ul>\r\n          </div>\r\n          <div ng-show=\"currentView == \'list\'\" class=\"col-md-8\">\r\n            <user-form user=\"selectedUser\" title=\"User Details\" submit-text=\"Save Changes\" submit=\"saveUser(user)\" destroy=\"deleteUser(user)\"></user-form>\r\n          </div>\r\n          <div ng-show=\"currentView == \'form\'\" class=\"col-md-8\">\r\n            <user-form title=\"New User\" user=\"newUser\" submit-text=\"Create User\" submit=\"saveUser(user)\"></user-form>\r\n          </div>\r\n        </div>      \r\n        <div ng-hide=\"selectedUser\">\r\n          <div class=\"col-md-4\">\r\n            <h4>Users</h4>\r\n            No Users found for this organisation.\r\n            You can create one by entering the details on this page.\r\n          </div>\r\n          <div class=\"col-md-4\">\r\n            <h4>Create New User</h4>\r\n            <user-form title=\"New User\" user=\"newUser\" submit-text=\"Create User\" submit=\"saveUser(user)\"></user-form>\r\n          </div>\r\n        </div>\r\n      </div>\r\n    </div>\r\n  </div>\r\n</div>");}]);
angular.module('gi.security').filter('userName', [
  'giUser', function(User) {
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

angular.module('gi.security').directive('auth', [
  '$location', '$rootScope', function($location, $rootScope) {
    var link;
    link = function(scope, elem, attrs) {
      var path;
      path = $location.path();
      scope.$on('event:auth-loginRequired', function() {
        path = $location.path();
        return $location.path('/login');
      });
      return scope.$on('event:auth-loginConfirmed', function() {
        if (path === '/logout' || path === '/login') {
          path = '/';
        }
        return $location.path(path);
      });
    };
    return {
      link: link,
      restrict: 'C'
    };
  }
]);

angular.module('gi.security').directive('giRolePicker', [
  '$filter', function($filter) {
    return {
      restrict: 'E',
      scope: {
        model: '='
      },
      templateUrl: 'gi-rolePicker.html',
      link: {
        pre: function($scope) {
          var refresh;
          $scope.my = {};
          refresh = function() {
            $scope.model.chosenItems = [];
            $scope.model.availableItems = [];
            return angular.forEach($scope.model.roles, function(role) {
              var found;
              found = false;
              angular.forEach($scope.model.chosen, function(memberId) {
                if (memberId.toString() === role._id.toString()) {
                  return found = true;
                }
              });
              if (found) {
                return $scope.model.chosenItems.push(role);
              } else {
                return $scope.model.availableItems.push(role);
              }
            });
          };
          $scope.$watch('model.roles', function(newVal, oldVal) {
            if (newVal != null) {
              return refresh();
            }
          });
          return $scope.$watch('model.item', function(newVal, oldVal) {
            if ((newVal != null) && newVal._id !== (oldVal != null ? oldVal._id : void 0)) {
              return refresh();
            }
          });
        }
      }
    };
  }
]);

angular.module('gi.security').directive('giPassword', [
  'giUser', function(User) {
    return {
      restrict: 'A',
      require: 'ngModel',
      compile: function(elem, attrs) {
        var linkFn;
        linkFn = function($scope, elem, attrs, controller) {
          var $viewValue, ngModelController;
          ngModelController = controller;
          $viewValue = function() {
            return ngModelController.$viewValue;
          };
          return ngModelController.$validators.giPassword = function(x) {
            return User.testPassword(x);
          };
        };
        return linkFn;
      }
    };
  }
]);

angular.module('gi.security').directive('permissionForm', [
  '$q', '$timeout', '$http', '$filter', 'Resource', 'giUser', 'Permission', function($q, $timeout, $http, $filter, Resource, User, Permission) {
    return {
      restrict: 'E',
      templateUrl: 'gi-permissionForm.html',
      scope: {
        permission: '=',
        submit: '&',
        destroy: '&',
        submitText: '@'
      },
      link: function(scope, elm, attrs) {
        var getRelatedKeys, getResources, getSelectedKeys, getSelectedResourceType, getSelectedUser, getUsers, pluralise, refreshPermissionFields;
        scope.resourceTypes = [];
        scope.keys = [];
        scope.selectedKeys = [];
        scope.users = [];
        scope.showDelete = true;
        scope.showDeleteModal = false;
        scope.restrictions = Permission.restrictions;
        scope.$watch('permission', function(newVal, oldVal) {
          return refreshPermissionFields();
        });
        scope.$watch('selectedResourceType', function(newVal, oldVal) {
          if (newVal != null ? newVal.name : void 0) {
            scope.selectedKeys = [];
            return getRelatedKeys(newVal.name);
          }
        });
        pluralise = function(str) {
          var result, suffix;
          if (str != null) {
            result = str.toLowerCase();
            suffix = 'y';
            if (result.indexOf(suffix, result.length - suffix.length) !== -1) {
              result = result.substring(0, result.length - 1) + 'ies';
            } else {
              result += 's';
            }
            return result;
          } else {
            return str;
          }
        };
        getRelatedKeys = function(name) {
          var uri;
          uri = '/api/' + pluralise(name);
          return $http.get(uri).success(function(data) {
            scope.selectedKeys = [];
            scope.keys = data;
            angular.forEach(scope.keys, function(key) {
              return key.id = key._id;
            });
            return getSelectedKeys();
          });
        };
        scope.deletePermission = function() {
          scope.destroy({
            permission: scope.permission
          });
          return scope.showDeleteModal = false;
        };
        scope.confirmDelete = function() {
          return scope.showDeleteModal = true;
        };
        getUsers = function() {
          var deferred;
          deferred = $q.defer();
          User.all(function(users) {
            scope.users = users;
            angular.forEach(scope.users, function(user) {
              return user.id = user._id;
            });
            deferred.resolve();
          });
          return deferred.promise;
        };
        getResources = function() {
          var deferred;
          deferred = $q.defer();
          Resource.all().then(function(resources) {
            scope.resourceTypes = resources;
            angular.forEach(scope.resourceTypes, function(resource) {
              return resource.id = resource._id;
            });
            deferred.resolve();
          });
          return deferred.promise;
        };
        getSelectedResourceType = function() {
          scope.selectedResourceType = {};
          if (scope.permission) {
            if (scope.permission.resourceType) {
              return angular.forEach(scope.resourceTypes, function(resource) {
                if (resource.name === scope.permission.resourceType) {
                  return scope.selectedResourceType = resource;
                }
              });
            }
          }
        };
        getSelectedUser = function() {
          scope.selectedUser = {};
          if (scope.permission) {
            if (scope.permission.userId) {
              return angular.forEach(scope.users, function(user) {
                if (user._id === scope.permission.userId) {
                  return scope.selectedUser = user;
                }
              });
            }
          }
        };
        getSelectedKeys = function() {
          scope.selectedKeys = [];
          if (scope.permission && (scope.permission.keys != null)) {
            return scope.selectedKeys = $filter('filter')(scope.keys, function(key) {
              return scope.permission.keys.indexOf(key._id) !== -1;
            });
          }
        };
        refreshPermissionFields = function() {
          $timeout(getSelectedResourceType);
          $timeout(getSelectedUser);
          return $timeout(getSelectedKeys);
        };
        scope.save = function() {
          var key;
          if (scope.permission) {
            scope.permission.userId = scope.selectedUser._id;
            scope.permission.keys = (function() {
              var i, len, ref, results;
              ref = scope.selectedKeys;
              results = [];
              for (i = 0, len = ref.length; i < len; i++) {
                key = ref[i];
                results.push(key._id);
              }
              return results;
            })();
            scope.permission.resourceType = scope.selectedResourceType.name;
            return scope.submit({
              permission: scope.permission
            });
          }
        };
        return $q.all([getResources(), getUsers()]).then(function() {
          return refreshPermissionFields();
        });
      }
    };
  }
]);

angular.module('gi.security').directive('roleForm', function() {
  return {
    restrict: 'E',
    templateUrl: 'gi-roleForm.html',
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

var indexOf = [].indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

angular.module('gi.security').directive('userForm', [
  'Role', function(Role) {
    return {
      restrict: 'E',
      templateUrl: 'gi-userForm.html',
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
            var ref, ref1;
            if ((((ref = scope.user) != null ? ref.roles : void 0) != null) && (ref1 = role._id, indexOf.call(scope.user.roles, ref1) >= 0)) {
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
          scope.unsavedChanges = true;
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

angular.module('gi.security').directive('giUsername', [
  'giUser', '$q', '$parse', function(User, $q, $parse) {
    return {
      restrict: 'A',
      require: 'ngModel',
      compile: function(elem, attrs) {
        var linkFn;
        linkFn = function($scope, elem, attrs, controller) {
          var $viewValue, needToCheck, ngModelController, requiredGetter;
          ngModelController = controller;
          $viewValue = function() {
            return ngModelController.$viewValue;
          };
          requiredGetter = $parse(attrs.giUsername);
          needToCheck = function() {
            return (attrs.giUsername === "") || requiredGetter($scope);
          };
          $scope.$watch('item.register', function(newVal) {
            return ngModelController.$$parseAndValidate();
          });
          return ngModelController.$asyncValidators.giUsername = function(modelValue, viewValue) {
            var deferred;
            deferred = $q.defer();
            if (needToCheck()) {
              User.isUsernameAvailable(modelValue).then(function(valid) {
                if (valid) {
                  return deferred.resolve();
                } else {
                  return deferred.reject();
                }
              });
            } else {
              deferred.resolve();
            }
            return deferred.promise;
          };
        };
        return linkFn;
      }
    };
  }
]);

angular.module('gi.security').config([
  '$httpProvider', 'AuthProvider', function($httpProvider, AuthProvider) {
    return $httpProvider.interceptors.push([
      '$rootScope', '$q', function($rootScope, $q) {
        return {
          responseError: function(rejection) {
            var deferred;
            if ((rejection.config.url !== '/api/login') && (rejection.config.url !== '/api/user') && (rejection.status === 401)) {
              deferred = $q.defer();
              AuthProvider.pushToBuffer(rejection.config, deferred);
              $rootScope.$broadcast('event:auth-loginRequired');
              return deferred.promise;
            } else {
              return $q.reject(rejection);
            }
          }
        };
      }
    ]);
  }
]);

angular.module('gi.security').provider('Auth', function() {

  /*
  Holds all the requests which failed due to 401 response,
  so they can be re-requested in future, once login is completed.
   */
  var buffer, get, pushToBuffer;
  buffer = [];

  /*
  Required by HTTP interceptor.
  Function is attached to provider to be invisible for
  regular users of this service.
   */
  pushToBuffer = function(config, deferred) {
    return buffer.push({
      config: config,
      deferred: deferred
    });
  };
  get = [
    '$rootScope', '$injector', '$q', '$filter', 'Role', 'Setting', 'giGeo', 'giLog', function($rootScope, $injector, $q, $filter, Role, Setting, Geo, Log) {
      var $http, fireLoginChangeEvent, firstRequest, getCountry, getLoggedInUser, getRoleName, loginChanged, loginInfoDirty, loginStatus, me, retry, retryAll;
      $http = void 0;
      loginInfoDirty = true;
      firstRequest = true;
      me = {
        user: null,
        isAdmin: false,
        isRestricted: true,
        loggedIn: false,
        countryCode: "N/A"
      };
      retry = function(config, deferred) {
        $http = $http || $injector.get('$http');
        return $http(config).then(function(response) {
          return deferred.resolve(response);
        });
      };
      retryAll = function() {
        var i, item, len;
        for (i = 0, len = buffer.length; i < len; i++) {
          item = buffer[i];
          retry(item.config, item.deferred);
        }
        return buffer = [];
      };
      getRoleName = function(settings, settingName, defaultValue) {
        var roleSetting;
        roleSetting = $filter('filter')(settings, function(setting) {
          return setting.key === settingName;
        });
        settingName = defaultValue;
        if ((roleSetting != null ? roleSetting.length : void 0) > 0) {
          settingName = roleSetting[0].value;
        }
        return settingName;
      };
      getCountry = function(me) {
        var deferred, ref;
        deferred = $q.defer();
        if ((me != null ? (ref = me.user) != null ? ref.countryCode : void 0 : void 0) != null) {
          me.countryCode = me.user.countryCode;
          deferred.resolve(me);
        } else {
          Geo.country().then(function(code) {
            me.countryCode = code;
            return deferred.resolve(me);
          }, function(error) {
            me.countryCode = "N/A";
            return deferred.resolve(me);
          });
        }
        return deferred.promise;
      };
      getLoggedInUser = function() {
        var deferred, wasLoggedIn, wasLoggedOut;
        deferred = $q.defer();
        wasLoggedIn = me.loggedIn;
        wasLoggedOut = !me.loggedIn;
        $http = $http || $injector.get('$http');
        $http.get('/api/user').success(function(user) {
          return $http.get("/api/cohorts/userCohorts/" + user._id).success(function(cohorts) {
            var cohortsString;
            if (window.dataLayer) {
              cohortsString = cohorts.reduce(function(accum, el) {
                return (accum.length ? accum + '; ' + el : accum + el);
              }, '');
              window.dataLayer.push({
                userCohorts: cohortsString
              });
            }
            return Setting.all().then(function(settings) {
              var admin, clientAdmin, readOnlyAdmin, restricted, sysAdmin;
              admin = getRoleName(settings, "AdminRoleName", "admin");
              restricted = getRoleName(settings, "RestrictedRoleName", "restricted");
              sysAdmin = getRoleName(settings, "SysAdminRoleName", "sysadmin");
              clientAdmin = getRoleName(settings, "ClientAdminRoleName", "clientadmin");
              readOnlyAdmin = getRoleName(settings, "ReadOnlyAdminRoleName", "readonlyadmin");
              return Role.isInRole(admin, user.roles).then(function(isAdmin) {
                return Role.isInRole(sysAdmin, user.roles).then(function(isSysAdmin) {
                  return Role.isInRole(clientAdmin, user.roles).then(function(isClientAdmin) {
                    return Role.isInRole(readOnlyAdmin, user.roles).then(function(isReadOnlyAdmin) {
                      return Role.isInRole(restricted, user.roles).then(function(isRestricted) {
                        loginInfoDirty = false;
                        me = {
                          user: user,
                          isAdmin: isAdmin,
                          isSysAdmin: isSysAdmin,
                          isClientAdmin: isClientAdmin,
                          isReadOnlyAdmin: isReadOnlyAdmin,
                          isRestricted: isRestricted,
                          loggedIn: true,
                          userCohorts: cohorts
                        };
                        return getCountry(me).then(function() {
                          if (wasLoggedOut) {
                            fireLoginChangeEvent();
                          }
                          return deferred.resolve(me);
                        });
                      });
                    });
                  });
                });
              });
            });
          }).error(function() {
            return Setting.all().then(function(settings) {
              var admin, clientAdmin, readOnlyAdmin, restricted, sysAdmin;
              admin = getRoleName(settings, "AdminRoleName", "admin");
              restricted = getRoleName(settings, "RestrictedRoleName", "restricted");
              sysAdmin = getRoleName(settings, "SysAdminRoleName", "sysadmin");
              clientAdmin = getRoleName(settings, "ClientAdminRoleName", "clientadmin");
              readOnlyAdmin = getRoleName(settings, "ReadOnlyAdminRoleName", "readonlyadmin");
              return Role.isInRole(admin, user.roles).then(function(isAdmin) {
                return Role.isInRole(sysAdmin, user.roles).then(function(isSysAdmin) {
                  return Role.isInRole(clientAdmin, user.roles).then(function(isClientAdmin) {
                    return Role.isInRole(readOnlyAdmin, user.roles).then(function(isReadOnlyAdmin) {
                      return Role.isInRole(restricted, user.roles).then(function(isRestricted) {
                        loginInfoDirty = false;
                        me = {
                          user: user,
                          isAdmin: isAdmin,
                          isSysAdmin: isSysAdmin,
                          isClientAdmin: isClientAdmin,
                          isReadOnlyAdmin: isReadOnlyAdmin,
                          isRestricted: isRestricted,
                          loggedIn: true,
                          userCohorts: []
                        };
                        return getCountry(me).then(function() {
                          if (wasLoggedOut) {
                            fireLoginChangeEvent();
                          }
                          return deferred.resolve(me);
                        });
                      });
                    });
                  });
                });
              });
            });
          });
        }).error(function() {
          loginInfoDirty = false;
          me = {
            user: null,
            isAdmin: false,
            isRestricted: true,
            loggedIn: false
          };
          return getCountry(me).then(function() {
            if (wasLoggedIn || firstRequest) {
              fireLoginChangeEvent();
            }
            return deferred.resolve(me);
          });
        });
        return deferred.promise;
      };
      fireLoginChangeEvent = function() {
        firstRequest = false;
        return $rootScope.$broadcast('event:auth-loginChange', me);
      };
      loginStatus = function() {
        var deferred;
        if (loginInfoDirty) {
          return getLoggedInUser();
        } else {
          deferred = $q.defer();
          deferred.resolve(me);
          return deferred.promise;
        }
      };
      loginChanged = function() {
        loginInfoDirty = true;
        return loginStatus();
      };
      return {
        me: loginStatus,
        loginChanged: loginChanged,
        loginConfirmed: function() {
          return loginChanged().then(retryAll);
        },
        isAdmin: function() {
          var deferred;
          deferred = $q.defer();
          loginStatus().then(function() {
            return deferred.resolve(me.isAdmin);
          });
          return deferred.promise;
        },
        isClientAdmin: function() {
          var deferred;
          deferred = $q.defer();
          loginStatus().then(function() {
            return deferred.resolve(me.isClientAdmin);
          });
          return deferred.promise;
        },
        isReadOnlyAdmin: function() {
          var deferred;
          deferred = $q.defer();
          loginStatus().then(function() {
            return deferred.resolve(me.isReadOnlyAdmin);
          });
          return deferred.promise;
        },
        logout: function() {
          var deferred;
          deferred = $q.defer();
          $http = $http || $injector.get('$http');
          $http.get('/api/logout').success(function() {
            return loginChanged().then(function() {
              return deferred.resolve();
            });
          });
          return deferred.promise;
        }
      };
    }
  ];
  return {
    $get: get,
    pushToBuffer: pushToBuffer
  };
});

angular.module('gi.security').factory('Facebook', [
  '$rootScope', '$http', '$q', function($rootScope, $http, $q) {
    var _appId, _facebookResponse, attemptServerLogin, init, login, loginStatus;
    _appId = null;
    init = function(appId) {
      if (_appId == null) {
        FB.init({
          appId: appId,
          status: false
        });
        return _appId = appId;
      }
    };
    loginStatus = function() {
      var deferred;
      deferred = $q.defer();
      FB.getLoginStatus(function(response) {
        if (response.status === 'connected') {
          return deferred.resolve(true);
        } else {
          return deferred.resolve(false);
        }
      });
      return deferred.promise;
    };
    attemptServerLogin = function(response) {
      var deferred;
      deferred = $q.defer();
      $http.post('/api/loginviafacebook', response).success(function() {
        return deferred.resolve(true);
      }).error(function() {
        return deferred.resolve(false);
      });
      return deferred.promise;
    };
    _facebookResponse = null;
    login = function() {
      var deferred;
      deferred = $q.defer();
      if (_facebookResponse == null) {
        FB.login(function(response) {
          _facebookResponse = response;
          if (_facebookResponse.status === 'connected') {
            return $rootScope.$apply(function() {
              return attemptServerLogin(_facebookResponse).then(function(loggedInNow) {
                return deferred.resolve(loggedInNow);
              });
            });
          } else {
            return deferred.resolve(false);
          }
        });
      } else {
        attemptServerLogin(_facebookResponse).then(function(loggedInNow) {
          return deferred.resolve(loggedInNow);
        });
      }
      return deferred.promise;
    };
    return {
      init: init,
      loginStatus: loginStatus,
      login: login
    };
  }
]);

angular.module('gi.security').factory('Permission', [
  '$resource', 'giCrud', function($resource, Crud) {
    var exports, restrictions;
    restrictions = [
      {
        name: 'Deny',
        value: 1
      }, {
        name: 'Create',
        value: 2
      }, {
        name: 'Read',
        value: 4
      }, {
        name: 'Update',
        value: 8
      }, {
        name: 'Destroy',
        value: 16
      }
    ];
    exports = Crud.factory('permissions');
    exports.restrictions = restrictions;
    return exports;
  }
]);

angular.module('gi.security').factory('Resource', [
  '$resource', 'giCrud', function($resource, Crud) {
    return Crud.factory('resources');
  }
]);

angular.module('gi.security').factory('Role', [
  '$filter', '$q', 'giCrud', function($filter, $q, Crud) {
    var crud, isInRole;
    crud = Crud.factory('roles');
    isInRole = function(name, roleIds) {
      var deferred;
      deferred = $q.defer();
      crud.all().then(function(roles) {
        var inRole, toCheck;
        inRole = false;
        toCheck = $filter('filter')(roles, function(role) {
          return role.name.toLowerCase() === name.toLowerCase();
        });
        angular.forEach(toCheck, function(role) {
          return angular.forEach(roleIds, function(id) {
            if (id === role._id) {
              return inRole = true;
            }
          });
        });
        return deferred.resolve(inRole);
      });
      return deferred.promise;
    };
    crud.isInRole = isInRole;
    return crud;
  }
]);

angular.module('gi.security').factory('Setting', [
  'giCrud', function(Crud) {
    return Crud.factory('settings');
  }
]);

angular.module('gi.security').provider('giUser', function() {
  var passwordRequirements;
  passwordRequirements = null;
  this.setPasswordRequirements = function(reqs) {
    return passwordRequirements = reqs;
  };
  this.$get = [
    '$q', '$http', 'Auth', 'giCrud', 'giLog', function($q, $http, Auth, Crud, Log) {
      var crud, isUsernameAvailable, login, register, testPassword, updateAccount, updatePassword;
      crud = Crud.factory('users');
      testPassword = function(pwd) {
        if (passwordRequirements != null) {
          return passwordRequirements.regexp.test(pwd);
        } else {
          return true;
        }
      };
      register = function(item) {
        return $http.post('/api/user/register', item);
      };
      login = function(cred, isAfterRegistration) {
        var deferred;
        deferred = $q.defer();
        if (isAfterRegistration) {
          setTimeout((function(cred) {
            $http.post('/api/login', cred).success(function() {
              Auth.loginConfirmed();
              return deferred.resolve();
            }).error(function() {
              Auth.loginChanged();
              return deferred.reject();
            });
          }), 400, cred);
        } else {
          $http.post('/api/login', cred).success(function() {
            Auth.loginConfirmed();
            return deferred.resolve();
          }).error(function() {
            Auth.loginChanged();
            return deferred.reject();
          });
        }
        return deferred.promise;
      };
      updateAccount = function(item) {
        var deferred;
        deferred = $q.defer();
        $http.put('/api/user/account', item).success(function() {
          return deferred.resolve();
        }).error(function(err) {
          return deferred.reject(err);
        });
        return deferred.promise;
      };
      updatePassword = function(item) {
        var deferred;
        deferred = $q.defer();
        $http.put('/api/user/password', item).success(function() {
          return deferred.resolve();
        }).error(function(err) {
          return deferred.reject(err);
        });
        return deferred.promise;
      };
      isUsernameAvailable = function(username) {
        var deferred;
        deferred = $q.defer();
        if (username != null) {
          $http.get('/api/user/isAvailable?username=' + encodeURIComponent(username)).success(function(data) {
            return deferred.resolve(data.available);
          }).error(function(data) {
            Log.warn("Is Username Available Errored");
            Log.warn(data);
            return deferred.reject();
          });
        } else {
          deferred.resolve(false);
        }
        return deferred.promise;
      };
      crud.register = register;
      crud.login = login;
      crud.updateAccount = updateAccount;
      crud.updatePassword = updatePassword;
      crud.testPassword = testPassword;
      crud.isUsernameAvailable = isUsernameAvailable;
      return crud;
    }
  ];
  return this;
});

angular.module('gi.security').factory('UserAccount', [
  '$resource', '$rootScope', '$http', '$q', function($resource, $rootScope, $http, $q) {
    var getMe, methods, resetAPISecret, resource;
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
    getMe = function() {
      var deferred;
      deferred = $q.defer();
      if (($rootScope.me != null) && ($rootScope.me._id != null)) {
        deferred.resolve($rootScope.me);
      } else {
        $http.get('/api/user').success(function(user) {
          return deferred.resolve(user);
        });
      }
      return deferred.promise;
    };
    resetAPISecret = function() {
      return getMe().then(function(me) {
        return $http.post('/api/user/apiSecret', {
          _id: me._id
        });
      });
    };
    return {
      get: resource.get,
      getMe: getMe,
      resetAPISecret: resetAPISecret
    };
  }
]);
