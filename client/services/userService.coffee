angular.module('app').factory 'User'
, ['$resource', ($resource) ->
  $resource '/api/users/:id', {}
  , { query: { method: 'GET', parms: {}, isArray: true} }
]