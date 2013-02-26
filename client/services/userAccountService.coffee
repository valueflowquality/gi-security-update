angular.module('app').factory 'UserAccount',
['$resource', '$rootScope', '$http'
, ($resource, $rootScope, $http) ->
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

  getMe = (callback) ->
    if $rootScope.me?
      callback($rootScope.me)
    else
      $http.get('/api/user')
        .success (user) ->
          callback(user) if callback

  get: resource.get
  getMe: getMe
]