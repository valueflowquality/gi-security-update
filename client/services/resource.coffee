angular.module('app').factory 'Resource'
, ['$resource', 'Crud'
, ($resource, Crud) ->

  Crud.factory 'resources', true
]