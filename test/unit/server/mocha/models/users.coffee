path = require 'path'
expect = require('chai').expect
moment = require 'moment'
mocks = require '../mocks'
sinon = mocks.sinon
dir =  path.normalize __dirname + '../../../../../../server'

module.exports = () ->
  describe 'Users', ->
    modelFactory = require(dir + '/models/users')
    model = null
    expectedDefinition =
      name: 'User'
      schemaDefinition:
        systemId: 'ObjectId'
        firstName: 'String'
        lastName: 'String'
        email: 'String'
        password: 'String'
        apiSecret: 'String'
        userIds: [{provider: 'String', providerId: 'String'}]
        roles: [{type: 'ObjectId', ref: 'Role'}]

   
    it 'Exports a factory function', (done) ->
      expect(modelFactory).to.be.a 'function'
      done()

    describe 'Constructor: (dal) -> {object}', ->
      beforeEach (done) ->
        sinon.spy mocks.dal, 'schemaFactory'
        sinon.spy mocks.dal, 'modelFactory'
        model = modelFactory mocks.dal
        done()
      
      afterEach (done) ->
        mocks.dal.modelFactory.restore()
        mocks.dal.schemaFactory.restore()
        done()

      it 'Creates a User schema', (done) ->
        expect(mocks.dal.schemaFactory.calledWithMatch(expectedDefinition))
        .to.be.true
        done()

      it 'Creates an User model', (done) ->
        returnedDefinition = mocks.dal.schemaFactory.returnValues[0]
        expect(mocks.dal.modelFactory.calledWithMatch(expectedDefinition))
        .to.be.true
        done()

    describe 'Schema', ->
      schema = null
      beforeEach ->
        sinon.spy mocks.dal, 'schemaFactory'
        model = modelFactory mocks.dal
        schema = mocks.dal.schemaFactory.returnValues[0]

      afterEach ->
        mocks.dal.schemaFactory.restore()

      it 'systemId: ObjectId', (done) ->
        expect(schema).to.have.property 'systemId', 'ObjectId'
        done()
      
      it 'firstName: String', (done) ->
        expect(schema).to.have.property 'firstName', 'String'
        done()

      it 'lastName: String', (done) ->
        expect(schema).to.have.property 'lastName', 'String'
        done()

      it 'email: String', (done) ->
        expect(schema).to.have.property 'email', 'String'
        done()

      it 'password: String', (done) ->
        expect(schema).to.have.property 'password', 'String'
        done()

      it 'apiSecret: String', (done) ->
        expect(schema).to.have.property 'apiSecret', 'String'
        done()

      it 'userIds: [{provider: String, providerId: String}]', (done) ->
        expect(schema).to.have.property 'userIds'
        expect(schema.userIds).to.be.an 'array'
        expect(schema.userIds.length).to.equal 1
        expect(schema.userIds[0]).to.deep.equal(
          {provider: 'String', providerId: 'String'}
        )
        done()

      it 'roles: [{type: ObjectId, ref: Role}]', (done) ->
        expect(schema).to.have.property 'roles'
        expect(schema.roles).to.be.an 'array'
        expect(schema.roles.length).to.equal 1
        expect(schema.roles[0]).to.deep.equal {type: 'ObjectId', ref: 'Role'}
        done()

    describe 'Exports',  ->
      mut = require(dir + '/models/users')(mocks.dal)
      mocks.exportsCrudModel 'User', mut, {update: true}
      
      describe 'Overriden Crud', ->
        it 'update: function(id, json, callback) -> (err, obj)', (done) ->
          done()
      describe 'Other', ->
        it 'findOrCreate: function(json, callback) -> (err, obj)', (done) ->
          done()

        it 'findOneByProviderId: function(id, systemId, callback)' +
        '-> (err, obj)', (done) ->
          done()