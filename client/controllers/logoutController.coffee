angular.module('app').controller 'logoutController'
, [ 'Auth', (Auth) ->
  Auth.logout()
]