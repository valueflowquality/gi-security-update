assert = require('chai').assert
expect = require('chai').expect
sinon = require 'sinon'
proxyquire = require 'proxyquire'
path = require 'path'

activities = require './activities'
roles = require './roles'
users = require './users'
permissions = require './permissions'
resources = require './resources'

module.exports = () ->
  describe 'Models', ->
    stubs = null
    models = null
    mongooseMock = null
    crudModelFactoryMock = null
    filesStub = null
    environmentsStub = null
    
    beforeEach (done) ->
      dir =  path.normalize __dirname + '../../../../server'

      filesStub =
        name: 'File'

      environmentsStub =
        name: 'Environment'

      stubs =
        './environments': sinon.stub().returns environmentsStub
        './files': sinon.stub().returns filesStub
        './systems': sinon.stub().returns {name: 'System'}
        './users': sinon.stub().returns {name: 'User'}
        './roles': sinon.stub().returns {name: 'Role'}
        './settings': sinon.stub().returns {name: 'Setting'}
        './categories': sinon.stub().returns {name: 'Category'}
        './activities': sinon.stub().returns {name: 'Activity'}
        './permissions': sinon.stub().returns {name: 'Permission'}
        './resources': sinon.stub().returns {name: 'Resource'}

      mongooseMock = sinon.spy()
      crudModelFactoryMock = sinon.spy()

      models = proxyquire(dir + '/models', stubs)(
        mongooseMock, crudModelFactoryMock
      )

      done()

    it 'exports activities model', (done) ->
      assert.ok stubs['./activities'].calledOnce
      assert stubs['./activities'].calledWithExactly(
        mongooseMock, crudModelFactoryMock), 'activities not initalized'
      assert.property models, 'activities', 'models does not export activities'
      expect(models.activities.name).to.equal 'Activity'
      done()

    activities()

    it 'exports categories model', (done) ->
      assert.ok stubs['./categories'].calledOnce
      assert stubs['./categories'].calledWithExactly(
        mongooseMock, crudModelFactoryMock, filesStub
      ), 'categories not initalized'
      assert.property models, 'categories'
      , 'models does not export categories'
      expect(models.categories.name).to.equal 'Category'
      done()

    it 'exports systems model', (done) ->
      assert.ok stubs['./systems'].calledOnce
      assert stubs['./systems'].calledWithExactly(
        mongooseMock, crudModelFactoryMock
      ), 'systems not initalized'
      assert.property models, 'systems'
      , 'models does not export systems'
      expect(models.systems.name).to.equal 'System'
      done()

    it 'exports environments model', (done) ->
      assert.ok stubs['./environments'].calledOnce
      assert stubs['./environments'].calledWithExactly(
        mongooseMock, crudModelFactoryMock
      ), 'environments not initalized'
      assert.property models, 'environments'
      , 'models does not export environments'
      expect(models.environments.name).to.equal 'Environment'
      done()

    it 'exports files model', (done) ->
      assert.ok stubs['./files'].calledOnce
      assert stubs['./files'].calledWithExactly(
        mongooseMock, crudModelFactoryMock), 'files not initalized'
      assert.property models, 'files', 'models does not export files'
      expect(models.files.name).to.equal 'File'
      done()

    it 'exports users model', (done) ->
      assert.ok stubs['./users'].calledOnce
      assert stubs['./users'].calledWithExactly(
        mongooseMock, crudModelFactoryMock), 'users not initalized'
      assert.property models, 'users', 'models does not export users'
      expect(models.users.name).to.equal 'User'
      done()
    
    users()

    it 'exports roles model', (done) ->
      assert.ok stubs['./roles'].calledOnce
      assert stubs['./roles'].calledWithExactly(
        mongooseMock, crudModelFactoryMock), 'roles not initalized'
      assert.property models, 'roles', 'models does not export roles'
      expect(models.roles.name).to.equal 'Role'
      done()
    
    roles()

    it 'exports settings model', (done) ->
      assert.ok stubs['./settings'].calledOnce
      assert stubs['./settings'].calledWithExactly(
        mongooseMock, crudModelFactoryMock, environmentsStub
      ), 'settings not initalized'
      assert.property models, 'roles', 'models does not export settings'
      expect(models.settings.name).to.equal 'Setting'
      done()

    it 'exports permissions model', (done) ->
      assert.ok stubs['./permissions'].calledOnce
      assert stubs['./permissions'].calledWithExactly(
        mongooseMock, crudModelFactoryMock), 'permissions not initalized'
      assert.property models, 'permissions'
      , 'models does not export permissions'
      expect(models.permissions.name).to.equal 'Permission'
      done()

    permissions()

    it 'exports resources model', (done) ->
      assert.ok stubs['./resources'].calledOnce
      assert stubs['./resources'].calledWithExactly(
        mongooseMock, crudModelFactoryMock), 'resources not initalized'
      assert.property models, 'resources', 'models does not export resources'
      expect(models.resources.name).to.equal 'Resource'
      done()

    resources()
