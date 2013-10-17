describe 'Role Controller', ->
  beforeEach angular.mock.module 'ngResource'
  beforeEach angular.mock.module 'app'

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

  mockAuthService =
    isAdmin: ->
      then: (cb) ->
        cb true

  scope = {}
  ctrl = {}

  beforeEach inject ($rootScope, $injector, $controller) ->
    scope = $rootScope.$new()

    dependencies =
      $scope: scope
      Role: mockRoleService
      User: mockUserService
      Auth: mockAuthService

    ctrl = $controller 'roleController', dependencies

  describe 'initializing', ->
    it 'should create an empty role',() ->
      expect(scope.newRole).to.deep.equal mockRoleService.create()

    it 'should select the first returned role', () ->
      expect(scope.selectedRole).to.deep.equal mockRoleService.roles[0]

  describe 'saving a new role', ->
    it 'should reset newRole after saving', () ->
      scope.show 'form'
      scope.newRole.name = "bob"
      scope.saveRole {}, () ->
        expect(scope.newRole).to.deep.equal mockRoleService.create()
        expect(scope.currentView).to.equal 'form'