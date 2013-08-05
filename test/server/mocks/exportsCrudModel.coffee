module.exports = (name, model) ->
  describe 'Crud Model Exports', ->
    it "name: #{name}", (done) ->
      model.name.should.equal name
      done()

    it 'find: function(options, callback) -> (err, [obj])', (done) ->
      model.should.have.property 'find', 'crudModel find'
      done()

    it 'findById: function(id, systemId, callback) -> (err, obj)', (done) ->
      model.should.have.property 'findById', 'crudModel findById'
      done()

    it 'findOne: function(query, callback) -> (err, obj)', (done) ->
      model.should.have.property 'findOne', 'crudModel findOne'
      done()

    it 'findOneBy: function(key, value, systemId, callback) -> (err, obj)', (done) ->
      model.should.have.property 'findOneBy', 'crudModel findOneBy'
      done()

    it 'create: function(json, callback) -> (err, obj)', (done) ->
      model.should.have.property 'create', 'crudModel create'
      done()

    it 'update: function(id, json, callback) -> (err, obj)', (done) ->
      model.should.have.property 'update', 'crudModel update'
      done()

    it 'destroy: function(id, systemId, callback) -> (err)', (done) ->
      model.should.have.property 'destroy', 'crudModel destroy'
      done()