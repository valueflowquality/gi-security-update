angular.module('gi.security').factory 'Resource'
, ['$resource', 'giCrud'
, ($resource, Crud) ->

  Crud.factory 'resources', true
]