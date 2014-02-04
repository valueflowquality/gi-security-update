angular.module('gint.security').controller 'logoutController'
, [ 'Auth', (Auth) ->
  Auth.logout()
]