angular.module('gi.security').filter 'permissionUser'
, [ '$filter'
, ($filter) ->
  (permission) ->
    result = 'Unknown'
    if permission and permission.userId
      result = $filter('userName')(permission.userId)
    result
]