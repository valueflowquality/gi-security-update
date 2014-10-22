angular.module('gi.security').factory 'User'
, ['$q', '$http', 'Auth', 'giCrud'
, ($q, $http, Auth, Crud) ->

  crud = Crud.factory 'users'

  register = (item) ->
    $http.post '/api/user/register', item

  login = (cred) ->
    deferred = $q.defer()
    $http.post('/api/login', cred).success( () ->
      Auth.loginConfirmed()
      deferred.resolve()
    ).error () ->
      Auth.loginChanged()
      deferred.reject()
    deferred.promise

  crud.register = register
  crud.login = login
  crud
]
