_ = require 'underscore'
gint = require 'gint-util'

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

  index = (req, res) ->
    crud.index req, res, () ->
      _.each res.gintResult, (u) ->
        u.password = null
        delete u.password
      res.json 200, res.gintResult

  findById = (req, res) ->
    crud.show req, res, () ->
      res.gintResult.password = null
      delete res.gintResult.password
      res.json 200, res.gintResult

  create = (req, res) ->
    crud.create req, res, () ->
      res.gintResult.password = null
      delete res.gintResult.password
      res.json 200, res.gintResult

  update = (req, res) ->
    crud.update req, res, () ->
      res.gintResult.password = null
      delete res.gintResult.password
      res.json 200, res.gintResult

  exports = gint.common.extend {}, crud
  exports.index = index
  exports.show = findById
  exports.create = create
  exports.update = update
  exports.showMe = showMe
  exports.updateMe = updateMe
  exports.destroyMe = destroyMe
  exports.generateAPISecretForMe = generateAPISecretForMe
  exports