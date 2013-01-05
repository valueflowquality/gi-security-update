###global define, describe, beforeEach, module, it, inject, expect###

define ['libs/angularMocks', 'services/userService']
, () ->
  'use strict'

  beforeEach module 'ngResource'
  beforeEach module 'services'
  beforeEach () ->
    this.addMatchers { toEqualData: (expected) ->
      angular.equals this.actual, expected }

  describe 'users service', ->
    User = {}
    $httpBackend = {}
    beforeEach inject (_$httpBackend_, $injector) ->
      $httpBackend = _$httpBackend_
      $httpBackend.expectGET('/api/users')
      .respond [{name: 'Bob'}]

      User = $injector.get('User')

    it 'should query users at /api/users and receive an array', ()->
      result = User.query()
      $httpBackend.flush()
      expect(result).toEqualData [{name: 'Bob'}]