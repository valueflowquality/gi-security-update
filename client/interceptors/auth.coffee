angular.module('gi.security').config ['$httpProvider','AuthProvider'
, ($httpProvider, AuthProvider) ->
  
  $httpProvider.interceptors.push ['$rootScope', '$q'
  , ($rootScope, $q) ->
    responseError: (rejection) ->
      if (
        rejection.config.url isnt '/api/login'
      ) and (
        rejection.config.url isnt '/api/user'
      ) and (
        rejection.status is 401
      )
        console.log 'a ha!'
        deferred = $q.defer()
        AuthProvider.pushToBuffer rejection.config, deferred
        $rootScope.$broadcast 'event:auth-loginRequired'
        deferred.promise
      else
        $q.reject rejection
  ]
]