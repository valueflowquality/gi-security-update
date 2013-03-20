beforeEach module 'ngResource'
beforeEach module 'ui'
beforeEach module 'app'

beforeEach () ->
  this.addMatchers { toEqualData: (expected) ->
    angular.equals this.actual, expected }

mockRoleService =
  roles: [{name: 'aRole'}]
  query: (callback) ->
    callback(@roles) if callback
  create: () ->
    name: ''
  destroy: (id, callback) ->
    @roles = []
    callback(id) if callback
  save: (role, callback) ->
    if not role._id
      role._id = '1'
    @roles.push role
    callback() if callback

mockUserService =
  query: (callback) ->
    callback []

describe 'Role Controller', ->

  scope = {}
  ctrl = {}
  $rootScope = {}

  beforeEach inject ($rootScope, $injector, $controller) ->
    roleService = mockRoleService
    scope = $rootScope.$new()
    ctrl = $controller('roleController'
    , { $scope: scope, Role: mockRoleService, User: mockUserService })

  describe 'initializing', ->
    it 'should create an empty role',() ->
      expect(scope.newRole).toEqualData(mockRoleService.create())

    it 'should select the first returned role', () ->
      expect(scope.selectedRole).toEqualData(mockRoleService.roles[0])

  describe 'saving a new role', ->
    it 'should reset newRole after saving', () ->
      scope.show 'form'
      scope.newRole.name = "bob"
      scope.saveRole {}, () ->
        expect(scope.newRole).toEqualData(mockRoleService.create())
        expect(scope.currentView).toEqual('form')