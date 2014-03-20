_ = require 'underscore'
path = require 'path'
expect = require('chai').expect
sinon = require 'sinon'

dir =  path.normalize __dirname + '../../../../../../server'

module.exports = () ->
  describe 'User', ->

    alice = null
    bob = null

    userModel =
      name: 'users'
      create: (json, cb) ->
        cb null, json
      find: (options, cb) ->
        cb null, [alice, bob]
      findById: (id, systemId, cb) ->
        cb null, alice
      update: (id, json, cb) ->
        cb null, json
   
    controllerFactory = require dir + '/controllers/user'

    describe 'Exports', ->
      controller = null
      
      crudController =
        create: ->
        index: ->
        show: ->
        update: ->
        destroy: 'crud destroy'

      crudControllerFactory = () ->
        crudController

      beforeEach ->
        controller = controllerFactory userModel, crudControllerFactory
        alice =
          firstName: 'Alice'
          password: '123'
    
        bob =
          firstName: 'Bob'
          password: '456'

      describe 'Standard Crud', ->
        it 'destroy: function(req, res)', (done) ->
          expect(controller).to.have.ownProperty 'destroy'
          expect(controller.destroy).to.equal 'crud destroy'
          done()

      describe 'Overridden Crud', ->
        it 'index: function(req, res)', (done) ->
          expect(controller).to.have.ownProperty 'index'
          done()

        describe 'Index', ->
          
          beforeEach ->
            sinon.stub crudController, "index"
            crudController.index.callsArg 2

          afterEach ->
            crudController.index.restore()

          it 'Does not transmit passwords', (done) ->

            req =
              query:
                max: 3
            res =
              giResult: [alice, bob]
              json: (code, result) ->
                _.each result, (user) ->
                  expect(user.password).to.not.exist
                  expect(user).to.not.have.property 'password'
                done()

            controller.index req, res

        it 'create: function(req, res)', (done) ->
          expect(controller).to.have.ownProperty 'create'
          done()

        describe 'Create', ->

          beforeEach ->
            sinon.stub crudController, "create"
            crudController.create.callsArg 2

          afterEach ->
            crudController.create.restore()

          it 'Does not transmit passwords', (done) ->
            res =
              giResult: alice
              json: (code, result) ->
                expect(result.password).to.not.exist
                expect(result).to.not.have.property 'password'
                done()

            controller.create null, res

          it 'Does not transmit password after sucessful bulk create', (done) ->
            res =
              giResult: [
                {message: "ok", obj: alice}
                {message: "ok", obj: bob}
              ]
              giResultCode: 200

              json: (code, result) ->
                expect(code).to.equal 200
                _.each result, (r) ->
                  expect(r.obj.password).to.not.exist
                  expect(r.obj).to.not.have.property 'password'
                done()

            controller.create null, res

          it 'Does not transmit password after failed bulk create', (done) ->
            res =
              giResult: [
                {message: "not ok", obj: alice}
                {message: "ok", obj: bob}
              ]
              giResultCode: 500
              
              json: (code, result) ->
                expect(code).to.equal 500
                _.each result, (r) ->
                  expect(r.obj.password).to.not.exist
                  expect(r.obj).to.not.have.property 'password'
                done()

            controller.create null, res

        it 'update: function(req, res)', (done) ->
          expect(controller).to.have.ownProperty 'update'
          done()

        describe 'Update', ->
          beforeEach ->
            sinon.stub crudController, "update"
            crudController.update.callsArg 2

          afterEach ->
            crudController.update.restore()
          
          it 'Does not transmit passwords', (done) ->
            res =
              giResult: bob
              json: (code, result) ->
                expect(result.password).to.not.exist
                expect(result).to.not.have.property 'password'
                done()
            controller.update null, res

        it 'show: function(req, res)', (done) ->
          expect(controller).to.have.ownProperty 'show'
          done()
      
        describe 'Show', ->
          beforeEach ->
            sinon.stub crudController, "show"
            crudController.show.callsArg 2

          afterEach ->
            crudController.show.restore()

          it 'Does not transmit passwords', (done) ->
            res =
              giResult: alice
              json: (code, result) ->
                expect(result.password).to.not.exist
                expect(result).to.not.have.property 'password'
                done()
            controller.show null, res

      describe 'Other', ->

        describe 'showMe: function(req, res)', ->
          it 'Does not transmit passwords', (done) ->
            req =
              user:
                id: 'validId'
            res =
              json: (code, result) ->
                expect(result.password).to.not.exist
                expect(result).to.not.have.property 'password'
                done()
            controller.showMe req, res

        describe 'updateme: function(req, res)', ->
          it 'Does not transmit passwords', (done) ->
            req =
              user:
                id: '123'
              body:
                _id: '123'
                password: 'a password'
            res =
              json: (code, result) ->
                expect(result.password).to.not.exist
                expect(result).to.not.have.property 'password'
                done()
            controller.updateMe req, res