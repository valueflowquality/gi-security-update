describe 'Login controller', ->
  beforeEach angular.mock.module 'ngResource'
  beforeEach angular.mock.module 'gint.util'
  beforeEach angular.mock.module 'app'

  allSettingsResult = null
  mockSettingService = null
  mockAuthService = {}
  mockFacebookService = {}
  mockHttpService = {}
  mockFilterService = null
  controller = null
  scope = null
  ctrl = null
  q = null
  dependencies = null

  beforeEach inject ($rootScope, $httpBackend, $injector, $controller, $q
  , $filter) ->
    controller = $controller
    scope = $rootScope.$new()
    mockHttpService = $httpBackend

    q = $q
    
    allSettingsResult = sinon.stub()

    mockSettingService =
      all: () ->
        then: allSettingsResult

    mockFacebookService =
      init: sinon.spy()

    dependencies =
      $scope: scope
      $filter: $filter
      authService: mockAuthService
      Facebook: mockFacebookService
      Setting: mockSettingService

    sinon.spy console, 'log'

  afterEach ->
    console.log.restore()

  describe 'initializing', ->
    it 'Gets all settings', (done) ->
      sinon.spy mockSettingService, 'all'
      ctrl = controller 'loginController', dependencies
      expect(mockSettingService.all.calledOnce).to.be.true
      done()

    it 'sets allowFacebookLogin to the value in facebookAppId setting'
    , (done) ->
      allSettingsResult.callsArgWith 0, [
        {key: 'setting1', value: 'setting1'}
        {key: 'facebookAppId', value: 'setting2'}
        {key: 'loginWithFacebook', value: 'bob'}
      ]
      ctrl = controller 'loginController', dependencies
      expect(scope.allowFacebookLogin).to.equal 'bob'
      done()

    it 'sets allowFacebookLogin to false if no setting'
    , (done) ->
      allSettingsResult.callsArgWith 0, []
      ctrl = controller 'loginController', dependencies
      expect(scope.allowFacebookLogin).to.equal false
      done()

    it 'does not init facebook if facebook login is not enabled'
    , (done) ->
      allSettingsResult.callsArgWith 0, [
        {key: 'setting1', value: 'setting1'}
        {key: 'facebookAppId', value: 'setting2'}
      ]
      ctrl = controller 'loginController', dependencies
      expect(mockFacebookService.init.notCalled, 'facebook was initialised')
      .to.be.true
      expect(console.log.notCalled, 'tried to intialize facebook')
      .to.be.true
      done()

    it 'inits facebook with on the setting with key facebookAppId ' +
    'if facebook login is enabled', (done) ->
      allSettingsResult.callsArgWith 0, [
        {key: 'setting1', value: 'setting1'}
        {key: 'loginWithFacebook', value: true}
        {key: 'facebookAppId', value: 'setting2'}
      ]
      ctrl = controller 'loginController', dependencies
      expect(mockFacebookService.init.calledWithExactly 'setting2').to.be.true
      expect(console.log.called).to.be.false
      done()

    it 'logs an error to the console if no appId setting found', (done) ->
      allSettingsResult.callsArgWith 0, [
        {key: 'setting1', value: 'setting1'}
        {key: 'loginWithFacebook', value: true}
      ]
      ctrl = controller 'loginController', dependencies
      expect(console.log.calledWithExactly('error initializing facebook login')
      ,"initializing facebook login had problem")
      .to.be.true
      done()

    it 'sets scope.loginStatus.failed to false', (done) ->
      ctrl = controller 'loginController', dependencies
      expect(scope.loginStatus.failed).to.be.false
      done()
  describe '$scope functions', ->
    beforeEach ->
      ctrl = controller 'loginController', dependencies

    describe '$scope.login()', ->
      it 'sets $scope.loginStatus.failed to true if login fails', (done) ->
        scope.cred =
          username: 'bob@acme.com'
          password: 'pswd'
        mockHttpService.expectPOST('/api/login', scope.cred)
        .respond(401)
        scope.login()
        mockHttpService.flush()
        expect(scope.loginStatus.failed, 'loginStatus.failed not set')
        .to.be.true
        done()

    describe '$scope.dismissLoginAlert()', () ->
      it 'sets $scope.loginStatus.failed to false', (done) ->
        scope.loginStatus.failed = true
        scope.dismissLoginAlert()
        expect(scope.loginStatus.failed).to.be.false
        done()

