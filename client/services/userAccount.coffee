angular.module('gi.security').factory 'UserAccount',
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


  resetAPISecret = () ->
    getMe().then (me) ->
      $http.post('/api/user/apiSecret', {_id: me._id})

  get: resource.get
  getMe: getMe
  resetAPISecret: resetAPISecret

]