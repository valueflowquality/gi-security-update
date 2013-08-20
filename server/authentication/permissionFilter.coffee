_ = require 'underscore'
gint = require 'gint-util'

module.exports = (app) ->
  #Returns a middleware function that embelisshes
  #req.gintFilter with information used to filter results
  #based on permissions

  flags =
    NONE: 1
    CREATE: 2
    READ: 4
    UPDATE: 8
    DESTROY: 16

  (req, res, next) ->
   
    options =
      query:
        systemId: req.systemId
        userId: req.user.id

    app.models.permissions.find options, (err, results) ->
      if err
        res.json 500, {message: err}
      else if results?
        req.gintFilter = {}

        _.each results, (result) ->
          if not req.gintFilter[result.resourceType]
            req.gintFilter[result.resourceType] = {}

          resourceTypeFilter = req.gintFilter[result.resourceType]

          if result.restriction & flags.NONE
            if not resourceTypeFilter.$nin?
              resourceTypeFilter.$nin = []

            #console.log 'we are denied access to customer(s): ' + result.keys
            gint.common.extend resourceTypeFilter.$nin, result.keys

          if result.restriction & flags.CREATE
            resourceTypeFilter.create = true

          if result.restriction & flags.READ
            if not resourceTypeFilter.$in?
              resourceTypeFilter.$in = []
            gint.common.extend resourceTypeFilter.$in, result.keys

        next()
      else
        next()