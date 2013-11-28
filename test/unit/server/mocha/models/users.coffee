path = require 'path'
expect = require('chai').expect
moment = require 'moment'
mocks = require '../mocks'
sinon = mocks.sinon
dir =  path.normalize __dirname + '../../../../../../server'

module.exports = () ->
  describe 'Users', ->
    model = null
    modelName = 'User'
    beforeEach (done) ->
      sinon.spy mocks.dal, 'model'
      model = require(dir + '/models/users')(mocks.dal)
      done()
    
    afterEach (done) ->
      mocks.dal.model.restore()
      done()
    
    it 'Creates a User dal model', (done) ->
      expect(mocks.dal.model.calledWith(modelName
      , sinon.match.any)).to.be.true
      done()

    describe 'Schema', ->

      it 'systemId: ObjectId', (done) ->
        expect(mocks.dal.model.calledWith(modelName
        , sinon.match.has 'systemId', 'ObjectId')).to.be.true
        done()
      
      it 'firstName: String', (done) ->
        expect(mocks.dal.model.calledWith(modelName
        , sinon.match.has 'firstName', 'String')).to.be.true
        done()

      it 'lastName: String', (done) ->
        expect(mocks.dal.model.calledWith(modelName
        , sinon.match.has 'lastName', 'String')).to.be.true
        done()

      it 'email: String', (done) ->
        expect(mocks.dal.model.calledWith(modelName
        , sinon.match.has 'email', 'String')).to.be.true
        done()

      it 'password: String', (done) ->
        expect(mocks.dal.model.calledWith(modelName
        , sinon.match.has 'password', 'String')).to.be.true
        done()

      it 'apiSecret: String', (done) ->
        expect(mocks.dal.model.calledWith(modelName
        , sinon.match.has 'apiSecret', 'String')).to.be.true
        done()

      it 'userIds: [{provider: String, providerId: String}]', (done) ->
        expect(mocks.dal.model.calledWith(modelName
        , sinon.match.has 'userIds'
        , [{provider: 'String', providerId: 'String'}])).to.be.true
        done()

      it 'roles: [{type: ObjectId, ref: Role}]', (done) ->
        expect(mocks.dal.model.calledWith(modelName
        , sinon.match.has 'roles'
        , [{type: 'ObjectId', ref: 'Role'}])).to.be.true
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

#   it 'Hashes password on creation', (done) ->
#     model.create { firstName: 'bob', password: 'aPassword' }, (err, result) ->
#       #Check we're doing some sort of hash
#       result.password.should.not.equal 'aPassword'
#       result.comparePassword 'aPassword', (err, isMatch) ->
#         isMatch.should.equal(true)
#         result.comparePassword 'aBadPassword', (err, isNotMatch) ->
#           isNotMatch.should.equal(false)

#           done()

#   it 'Does not allow logins with blank passwords', (done) ->
#     model.create { firstName: 'bob' }, (err, result) ->
#       result.comparePassword '', (err, isMatch) ->
#         isMatch.should.be.false
#         result.comparePassword undefined, (err, isMatch2) ->
#           isMatch2.should.be.false
#           result.comparePassword null, (err, isMatch3) ->
#             isMatch3.should.be.false
#             done()

#   it 'Can update a password', (done) ->
#     model.create { firstName: 'bob', password: 'aPassword'}, (err, result) ->
#       result.comparePassword 'aPassword', (err, isMatch) ->
#         isMatch.should.be.true
#         model.update result._id
#         , {firstName: 'bob', password: 'anotherPassword'}
#         , (err, updatedUser) ->
#           updatedUser.comparePassword 'anotherPassword', (err, updateMatch) ->
#             updateMatch.should.be.true
#             done()

