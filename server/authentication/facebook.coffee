passport = require 'passport'
http = require 'http'
strategies = require './strategies'

module.exports = (users) ->
  passport.use new strategies.facebook.Strategy( (facebookid, done) ->
    http.get "http://graph.facebook.com/" +
    facebookid + "?fields=id%2Cname", (res) ->

      data = ''

      res.on 'data', (chunk) ->
        data += chunk

      res.on 'end', () ->
        body = JSON.parse data
        users.findOrCreate
          name: body.name
          providerId : body.id
          userIds: [{provider: 'Facebook', providerId: body.id}]
        , (err, user) ->
          done(err, user)

    .on 'error', (e) ->
      done e.message, null
  )

  routes: (app) ->
    app.post '/api/loginviafacebook'
    , passport.authenticate('facebook-sdk')
    , (req, res) ->
      res.json 200