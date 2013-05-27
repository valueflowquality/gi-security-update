passport = require 'passport'
http = require 'http'
strategies = require './strategies'

module.exports = (users) ->
  passport.use new strategies.basic.Strategy((email, password, done) ->
    console.log 'basic verify ' + email + ' ' + password
    users.findOneBy 'email', email, (err, user) ->
      console.log 'found user: ' + err + ' : ' + user
      if err
        done null, false, {message: err}
      else if not user
        done null, false, {message: 'User not found'}
      else
        user.comparePassword password, (err, isValid) ->
          if err
            done err
          else if not isValid
            done null, false, {message: 'Incorrect password'}
          else
            done null, user
  )

  routes: (app) ->
    app.post '/api/login'
    , passport.authenticate('basic')
    , (req, res) ->
      res.json 200