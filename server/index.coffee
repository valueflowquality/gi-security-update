module.exports = (app, users, options) ->
  require('./authentication')(app, users, options)