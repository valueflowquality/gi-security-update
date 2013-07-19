passport = require 'passport'
http = require 'http'
strategies = require './strategies'

module.exports = (users) ->
  passport.use new strategies.play.Strategy((userId, systemId, done) ->
    users.findById userId, systemId, (err, user) ->
      if err
        done err
      else if not user
        #valid hmac, but unknown user
        done null, false, { message: 'No user found with that userId'}
      else
        #success, the access Key is associated with a user
        done null, user
  )