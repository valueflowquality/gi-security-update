passport = require 'passport'
http = require 'http'
strategies = require './strategies'

module.exports = (users) ->
  passport.use new strategies.hmac.Strategy((accessKey, systemId, done) ->
    # if there is an error , we should return:    #   done(err)
    users.findById accessKey, systemId, (err, user) ->
      if err
        done err
      else if not user
        #valid hmac, but unknown user
        done null, false, { message: 'No user found with that accessKey'}
      else
        #success, the access Key is associated with a user
        done null, user
  )