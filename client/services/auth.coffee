angular.module('gi.security').provider 'Auth', () ->
  ###
  Holds all the requests which failed due to 401 response,
  so they can be re-requested in future, once login is completed.
  ###
  buffer = []
  
  ###
  Required by HTTP interceptor.
  Function is attached to provider to be invisible for
  regular users of this service.
  ###
  pushToBuffer = (config, deferred) ->
    buffer.push {
      config: config,
      deferred: deferred
    }
  
  get = ['$rootScope','$injector', '$q', '$filter', 'Role', 'Setting'
  , ($rootScope, $injector, $q, $filter, Role, Setting) ->
    #initialized later because of circular dependency problem
    $http = undefined
    loginInfoDirty = true
    me =
      user: null
      isAdmin: false
      isRestricted: true
      loggedIn: false

    retry = (config, deferred) ->
      $http = $http || $injector.get '$http'
      $http(config).then (response) ->
        deferred.resolve response

    retryAll = () ->
      retry(item.config, item.deferred) for item in buffer
      buffer = []

    getRoleName = (settings, settingName, defaultValue) ->
      roleSetting = $filter('filter')(settings, (setting) ->
        setting.key is settingName
      )
      settingName = defaultValue
      if roleSetting?.length > 0
        settingName = roleSetting[0].value
      settingName

    getLoggedInUser = ->
      deferred = $q.defer()

      $http = $http || $injector.get '$http'
      $http.get('/api/user')
      .success (user) ->

        Setting.all().then (settings) ->
          admin = getRoleName settings,"AdminRoleName", "admin"
          restricted = getRoleName settings, "RestrictedRoleName", "restricted"
          sysAdmin = getRoleName settings, "SysAdminRoleName", "sysadmin"
          Role.isInRole(admin, user.roles).then (isAdmin) ->
            Role.isInRole(sysAdmin, user.roles).then (isSysAdmin) ->
              Role.isInRole(restricted, user.roles).then (isRestricted) ->
                loginInfoDirty = false
                me =
                  user: user
                  isAdmin: isAdmin
                  isSysAdmin: isSysAdmin
                  isRestricted: isRestricted
                  loggedIn: true
                deferred.resolve me
      .error ->
        loginInfoDirty = false
        me =
          user: null
          isAdmin: false
          isRestricted: true
          loggedIn: false
        deferred.resolve me

      deferred.promise

    loginStatus = () ->
      deferred = $q.defer()
      if loginInfoDirty
        deferred.resolve getLoggedInUser()
      else
        deferred.resolve me

      deferred.promise

    loginChanged = () ->
      loginInfoDirty = true
      $rootScope.$broadcast 'event:auth-loginChange'

    me: loginStatus
    loginChanged: loginChanged
    loginConfirmed: () ->
      loginChanged()
      retryAll()

    isAdmin: ->
      deferred = $q.defer()
      loginStatus().then ->
        deferred.resolve me.isAdmin
      deferred.promise

    logout: () ->
      $http = $http || $injector.get '$http'
      $http.get('/api/logout')
      .success ->
        loginInfoDirty = true
        $rootScope.$broadcast 'event:auth-loginChange'
        me =
          user: null
          isAdmin: false
          isRestricted: true
          loggedIn: false
  ]

  $get: get
  pushToBuffer: pushToBuffer