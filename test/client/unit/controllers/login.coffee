describe 'Login controller', ->
  beforeEach angular.mock.module 'ngResource'
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

  beforeEach inject (_$rootScope_, $injector, $controller, $q, $filter) ->
    controller = $controller
    scope = _$rootScope_.$new()

    q = $q
    
    allSettingsResult = sinon.stub()

    mockSettingService =
      all: () ->
        then: allSettingsResult

    mockFilterService = sinon.stub()

    mockFacebookService =
      init: sinon.spy()

    dependencies =
      $scope: scope
      $http: mockHttpService
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

    it 'filters the settings looking for facebookAppId', (done) ->
      fun = ->
        null
      allSettingsResult.callsArgWith 0, ['setting1', 'setting2']

      mockFilterService.returns fun

      dependencies.$filter = mockFilterService

      ctrl = controller 'loginController', dependencies

      expect(mockFilterService.calledWithExactly 'filter').to.be.true
      done()

    it 'passes settings and a function into two filters', (done) ->
      settingResult = [
        {key: 'setting1', value: 'setting1'}
        {key: 'setting2', value: 'setting2'}
      ]
      allSettingsResult.callsArgWith 0, settingResult
      allSettingsResult.callsArgWith 0, settingResult
      aSpy = sinon.spy()
      mockFilterService.returns aSpy
      dependencies.$filter = mockFilterService
      ctrl = controller 'loginController', dependencies
      expect(aSpy.calledTwice).to.be.true
      expect(aSpy.alwaysCalledWith settingResult, sinon.match.func)
      .to.be.true
      done()

    it 'inits facebook with on the setting with key facebookAppId', (done) ->
      allSettingsResult.callsArgWith 0, [
        {key: 'setting1', value: 'setting1'}
        {key: 'facebookAppId', value: 'setting2'}
      ]
      ctrl = controller 'loginController', dependencies
      expect(mockFacebookService.init.calledWithExactly 'setting2').to.be.true
      expect(console.log.called).to.be.false
      done()      

    it 'logs an error to the console if no appId setting found', (done) ->
      allSettingsResult.callsArgWith 0, [
        {key: 'setting1', value: 'setting1'}
        {key: 'facebookAppId', value: 'setting2'}
      ]
      aSpy = sinon.spy()
      mockFilterService.returns aSpy
      dependencies.$filter = mockFilterService
      ctrl = controller 'loginController', dependencies
      expect(console.log.calledWithExactly 'error initializing facebook login')
      .to.be.true
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
      allSettingsResult.callsArgWith 0, [
        {key: 'setting1', value: 'setting1'}
        {key: 'facebookAppId', value: 'setting2'}
      ]
      ctrl = controller 'loginController', dependencies
      expect(scope.allowFacebookLogin).to.equal false
      done()      

