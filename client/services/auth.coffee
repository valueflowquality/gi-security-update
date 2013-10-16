angular.module('app').provider 'authService', () ->
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
  
  get = ['$rootScope','$injector', ($rootScope, $injector) ->
    #initialized later because of circular dependency problem
    $http = undefined
    retry = (config, deferred) ->
      $http = $http || $injector.get '$http'
      $http(config).then (response) ->
        deferred.resolve response

    retryAll = () ->
      retry(item.config, item.deferred) for item in buffer
      buffer = []

    {
      loginConfirmed: () ->
        $rootScope.$broadcast 'event:auth-loginConfirmed'
        retryAll()
    }
  ]

  $get: get
  pushToBuffer: pushToBuffer