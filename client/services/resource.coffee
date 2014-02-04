angular.module('gint.security').factory 'Resource'
, ['$resource', 'giCrud'
, ($resource, Crud) ->

  Crud.factory 'resources', true
]