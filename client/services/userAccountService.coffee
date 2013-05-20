angular.module('app').factory 'UserAccount',
['$resource', '$rootScope', '$http', '$q'
, ($resource, $rootScope, $http, $q) ->
  methods =
    query:
      method: 'GET'
      params: {}
      isArray: true
    resetApi:
      method: 'PUT'
      params:
        resetApi: true

  resource = $resource '/api/user', {}, methods

  getMe = () ->
    deferred = $q.defer()
    if $rootScope.me? and $rootScope.me._id?
      deferred.resolve $rootScope.me
    else
      $http.get('/api/user')
        .success (user) ->
          deferred.resolve user
    deferred.promise

  get: resource.get
  getMe: getMe
]