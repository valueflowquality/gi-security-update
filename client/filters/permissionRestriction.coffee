angular.module('gi.security').filter 'permissionRestriction'
, ['Permission'
, (Permission) ->
  (permission) ->
    result = "N/A"
    if permission and permission.restriction
      angular.forEach Permission.restrictions, (res) ->
        if res.value is permission.restriction
          result = res.name
    
    result
]