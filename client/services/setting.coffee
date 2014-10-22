angular.module('gi.security').factory 'Setting'
, ['giCrud'
, (Crud) ->
  Crud.factory 'settings'
]
