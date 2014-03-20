_ = require 'underscore'
gi = require 'gi-util'

module.exports = (model, crudControllerFactory) ->
  crud = crudControllerFactory(model)

  showMe = (req, res) ->
    model.findById req.user.id, req.systemId, (err, user) ->
      if err
        res.json 404
      else
        user.password = null
        delete user.password
        res.json 200, user
  updateMe = (req, res) ->
    #first check that the user we want to update is the user
    #making the request
    if req.user.id is not req.body._id
      res.json 401
    else
      req.body.systemId = req.systemId
      model.update req.user.id, req.body, (err, user) ->
        if err
          res.json 404
        else
          user.password = null
          delete user.password
          res.json 200, user

  destroyMe = (req, res) ->
    model.destroy req.user.id, req.systemId, (err) ->
      if err
        res.json 404
      else
        res.json 200

  generateAPISecretForMe = (req, res) ->
    if req.user.id is not req.body._id
      res.json 401
    else
      model.resetAPISecret req.user.id, req.systemId, (err) ->
        if err
          res.json 404
        else
          res.json 200

  stripPasswords = (res) ->
    if _.isArray res.giResult
      _.each res.giResult, (r) ->
        r.obj.password = null
        delete r.obj.password
      res.json res.giResultCode, res.giResult
    else
      res.giResult.password = null
      delete res.giResult.password
      res.json 200, res.giResult

  index = (req, res) ->
    crud.index req, res, () ->
      _.each res.giResult, (u) ->
        u.password = null
        delete u.password
      res.json 200, res.giResult

  findById = (req, res) ->
    crud.show req, res, () ->
      stripPasswords res

  create = (req, res) ->
    crud.create req, res, () ->
      stripPasswords res

  update = (req, res) ->
    crud.update req, res, () ->
      stripPasswords res
     

  exports = gi.common.extend {}, crud
  exports.index = index
  exports.show = findById
  exports.create = create
  exports.update = update
  exports.showMe = showMe
  exports.updateMe = updateMe
  exports.destroyMe = destroyMe
  exports.generateAPISecretForMe = generateAPISecretForMe
  exports