angular.module('app').controller 'loginController'
, ['$scope', '$http', '$filter'
, 'authService', 'Facebook', 'Setting'
, ( $scope, $http, $filter
, authService, Facebook, Setting) ->
  #when we're in this controller we should keep testing to see
  #if the user has managed to login yet.
  finishLogin = () ->
    $http.get('/api/loginstatus')
    .success (data, status) ->
      if data.loggedIn
        $scope.getLoggedInUser()
        authService.loginConfirmed()

  $scope.login = () ->
    $http.post('/api/login', $scope.cred).success () ->
      finishLogin()

  $scope.loginWithFacebook = () ->
    Facebook.login().then (loggedIn) ->
      if loggedIn
        finishLogin()

  Setting.all().then (settings) ->
    appId = $filter('filter')(settings, (setting) ->
      setting.key is 'facebookAppId'
    )
    if appId?
      Facebook.init appId[0].value
    else
      console.log 'error initializing facebook login'
]