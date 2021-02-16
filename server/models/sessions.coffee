module.exports = (dal) ->
  modelDefinition =
    name: 'Session'
    schemaDefinition:
      _id: 'String'
      session: 'String'
    options:
      collectionName: 'sessions'

  modelDefinition.schema = dal.schemaFactory modelDefinition
  model = dal.modelFactory modelDefinition
  MAX_ATTEMPTS = 5

  removeSession = (id, cookieData, cb) =>
    sessionData = { cookie: cookieData, passport: {} }
    retries = 0
    sessionDataString = JSON.stringify(sessionData)

    removeSessionData id, sessionDataString, cb, retries

  removeSessionData = (id, sessionDataString, cb, retries) ->
    model.update { _id: id }, {session: sessionDataString}, (err, response) ->
      if err
        console.log "An error occurred while removing the user session data", err
        cb err
      else
        ensureRemoval(id, sessionDataString, cb, retries)

  ensureRemoval = (id, sessionDataString, cb, retries) =>
    setTimeout(() ->
      model.findOne { _id: id }, (err, response) ->
        if err
          console.log "An error occurred while checking if the session data has been deleted", err
          cb err
        else
          if !response?.session || response.session == sessionDataString || retries >= MAX_ATTEMPTS
            cb null
          else
            retries++
            removeSessionData(id, sessionDataString, cb, retries)
    , 1000)

  exports = {}
  exports.removeSession = removeSession
  exports
