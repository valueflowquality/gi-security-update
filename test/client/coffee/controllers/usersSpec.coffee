###global define, describe, beforeEach, module, it, inject, expect###

define ['libs/angularMocks', 'controllers/usersController']
, (mocks, usersController) ->
  'use strict'

  beforeEach module 'ngResource'
  beforeEach module 'controllers'
  beforeEach module 'services'
  beforeEach () ->
    this.addMatchers { toEqualData: (expected) ->
      angular.equals this.actual, expected }

  describe 'users controller', ->
    scope = {}
    ctrl = {}
    $httpBackend = {}
    beforeEach inject (_$httpBackend_, $rootScope, $controller) ->
      $httpBackend = _$httpBackend_
      $httpBackend.expectGET('/api/users?max=10')
      .respond [{name: 'Nexus S'}, {name: 'Motorola DROID'}]
      scope = $rootScope.$new()
      ctrl = $controller('usersController', { $scope: scope })

    it 'should create a users model with 2 users',()->
      expect(scope.users).toEqual([])
      $httpBackend.flush()
     
      expect(scope.users).toEqualData([{name: 'Nexus S'},
                                   {name: 'Motorola DROID'}])