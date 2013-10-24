angular.module('app').factory 'Resource'
, ['$resource', 'giCrud'
, ($resource, Crud) ->

  Crud.factory 'resources', true
]