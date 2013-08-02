module.exports = (model) ->
  index: (req, res, next) ->
    next() if next
  update: () ->
  destroy: () ->
  show: () ->
  create: (req, res, next) ->
    model.create req.body, (err, obj) ->
      next(req.body) if next