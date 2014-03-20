angular.module('gi.security').factory 'Facebook'
, ['$rootScope', '$http', '$q'
, ($rootScope, $http, $q) ->
  _appId = null
  init = (appId) ->
    if not _appId?
      FB.init
        appId      : appId
        status     : false # check login status
      _appId = appId

  loginStatus = () ->
    deferred = $q.defer()
    FB.getLoginStatus (response) ->
      if response.status is 'connected'
        deferred.resolve true
      else
        deferred.resolve false

    deferred.promise

  attemptServerLogin = (response) ->
    deferred = $q.defer()
    $http.post('/api/loginviafacebook', response).success(() ->
      deferred.resolve true
    ).error( () ->
      deferred.resolve false
    )
    deferred.promise
  
  _facebookResponse = null
  
  login = () ->
    deferred = $q.defer()
    if not _facebookResponse?
      FB.login (response) ->
        _facebookResponse = response
        if _facebookResponse.status is 'connected'
          $rootScope.$apply () ->
            attemptServerLogin(_facebookResponse).then (loggedInNow) ->
              deferred.resolve loggedInNow
        else
          deferred.resolve false
    else
      attemptServerLogin(_facebookResponse).then (loggedInNow) ->
        deferred.resolve loggedInNow

    deferred.promise

  init: init
  loginStatus: loginStatus
  login: login
]