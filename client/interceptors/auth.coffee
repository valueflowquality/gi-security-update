angular.module('app').config ['$httpProvider','authServiceProvider'
, ($httpProvider, authServiceProvider) ->
  
  $httpProvider.interceptors.push ['$rootScope', '$q'
  , ($rootScope, $q) ->
    responseError: (rejection) ->
      if (
        rejection.config.url isnt '/api/login'
      ) and (
        rejection.status is 401
      )
        console.log 'a ha!'
        deferred = $q.defer()
        authServiceProvider.pushToBuffer rejection.config, deferred
        $rootScope.$broadcast 'event:auth-loginRequired'
        deferred.promise
      else
        $q.reject rejection
  ]
]