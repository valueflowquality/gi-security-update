beforeEach module 'ngResource'
beforeEach module 'ui'
beforeEach module 'app'

beforeEach () ->
  this.addMatchers { toEqualData: (expected) ->
    angular.equals this.actual, expected }

describe 'user', ->
  describe 'initializing', ->

    it 'should pass a test',()->
      expect(false).toBe(false)