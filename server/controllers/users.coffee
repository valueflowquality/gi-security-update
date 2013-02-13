module.exports = (models) ->

  create = (req, res) ->
    models.users.create req.body, (err, user) ->
      if err
        res.json 500
      else
        res.json 200, user

  destroy = (req, res) ->
    models.users.destroy req.params.id, (err) ->
      if err
        res.json 404
      else
        res.json 200

  index = (req, res) ->
   
    max = do () ->
      if  isNaN req.query.max
        10
      else
        req.query.max || 10

    models.users.find {sort: {name: 'desc'}, limit: max }, (err, result) ->
      if err
        res.json 404
      else
        res.json 200, result

  showMe = (req, res) ->
    models.users.findById req.user.id, (err, user) ->
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
      models.users.update req.body, (err, user) ->
        if err
          res.json 404
        else
          res.json 200, user

  destroyMe = (req, res) ->
    models.users.destroy req.user.id, (err) ->
      if err
        res.json 404
      else
        res.json 200

  resetapi = (req, res) ->
    models.users.findById req.user.id, (err, user) ->
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
   
  showMe: showMe
  updateMe: updateMe
  destroyMe: destroyMe
  index: index
  destroy: destroy