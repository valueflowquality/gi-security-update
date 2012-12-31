angular.module('app').factory 'UserAccount', ['$resource', ($resource) ->
  methods =
    query:
      method: 'GET'
      params: {}
      isArray: true
    resetApi:
      method: 'PUT'
      params:
        resetApi: true

  $resource '/api/user', {}, methods
]