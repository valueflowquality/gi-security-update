angular.module('gi.security').factory 'Permission'
, ['$resource', 'giCrud'
, ($resource, Crud) ->

  restrictions=
    [
      { name: 'Deny', value: 1 }
      { name: 'Create', value: 2 }
      { name: 'Read', value: 4 }
      { name: 'Update', value: 8 }
      { name: 'Destroy', value: 16 }
    ]

  exports = Crud.factory 'permissions', true
  exports.restrictions = restrictions
  exports
]