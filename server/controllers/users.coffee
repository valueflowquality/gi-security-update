gint = require 'gint-util'

module.exports = (model) ->
  crud = gint.controllers.crud(model)

  showMe = (req, res) ->
    model.findById req.user.id, (err, user) ->
      if err
        res.json 404
      else
        res.json 200, user
  updateMe = (req, res) ->
    #first check that the user we want to update is the user
    #making the request
    if req.user.id is not req.body._id
      res.json 401
    else
      model.update req.body, (err, user) ->
        if err
          res.json 404
        else
          res.json 200, user

  destroyMe = (req, res) ->
    model.destroy req.user.id, (err) ->
      if err
        res.json 404
      else
        res.json 200

  resetapi = (req, res) ->
    model.findById req.user.id, (err, user) ->
      if err
        res.json 500, err
      else if not user
        res.json 404
      else
        user.resetAPISecret (err2) ->
          if err2
            res.json 500, err2
          else
            console.log 'about to save user'
            user.save (err3, result) ->
              if err3
                res.json 500, err3
              else
                res.json 200, result

  updateMe = (req, res) ->
    #first check that the user we want to update is the user
    #making the request
    console.log req.query.resetApi
    if req.query.resetApi
      resetapi req, res
    else
      res.json 500, 'update not implemented'
  
  create: crud.create
  update: crud.update
  destroy: crud.destroy
  showMe: showMe
  updateMe: updateMe
  destroyMe: destroyMe
  index: crud.index
  destroy: crud.destroy
  show: crud.show