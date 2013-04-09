gint = require 'gint-util'
_ = require 'underscore'

module.exports = (model) ->
  crud = gint.controllers.crud(model)

  showMe = (req, res) ->
    model.findById req.user.id, (err, user) ->
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
      model.update req.user.id, req.body, (err, user) ->
        if err
          res.json 404
        else
          user.password = null
          delete user.password
          res.json 200, user

  destroyMe = (req, res) ->
    model.destroy req.user.id, (err) ->
      if err
        res.json 404
      else
        res.json 200

  index = (req, res) ->
    crud.index req, res, (err, result) ->
      if err
        res.json 404, err
      else
        _.each result, (u) ->
          u.password = null
          delete u.password
        res.json 200, result

  findById = (req, res) ->
    crud.show req, res, (err, result) ->
      if err
        res.json 404, err
      else if result
        result.password = null
        delete result.password
        res.json 200, result
      else
        res.json 404

  create = (req, res) ->
    crud.create req, res, (err, result) ->
      if err
        res.json 404, err
      else if result
        result.password = null
        delete result.password
        res.json 200, result
      else
        res.json 404
  update = (req, res) ->
    crud.update req, res, (err, result) ->
      if err
        res.json 404, err
      else if result
        result.password = null
        delete result.password
        res.json 200, result
      else
        res.json 404

  create: create
  update: update
  destroy: crud.destroy
  showMe: showMe
  updateMe: updateMe
  destroyMe: destroyMe
  index: index
  destroy: crud.destroy
  show: findById