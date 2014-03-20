angular.module('gi.security').controller 'logoutController'
, [ 'Auth', (Auth) ->
  Auth.logout()
]