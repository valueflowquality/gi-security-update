angular.module('gi.security').provider 'giUser', () ->
  passwordRequirements = null

  @setPasswordRequirements = (reqs) ->
    passwordRequirements = reqs

  @$get = ['$q', '$http', 'Auth', 'giCrud'
  , ($q, $http, Auth, Crud) ->
    crud = Crud.factory 'users'

    testPassword = (pwd) ->
      if passwordRequirements?
        return passwordRequirements.regexp.test pwd
      else
        return true

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

    saveMe = (item) ->
      deferred = $q.defer()
      $http.put('/api/user', item).success( () ->
        deferred.resolve()
      ).error () ->
        deferred.reject
      deferred.promise

    crud.register = register
    crud.login = login
    crud.saveMe = saveMe
    crud.testPassword = testPassword
    crud
  ]

  @
