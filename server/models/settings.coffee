gint = require 'gint-util'

module.exports = (dal, environmentsModel) ->

  name = 'Setting'

  schema =
    systemId: 'ObjectId'
    key: 'String'
    value: 'String'
    acl: 'String'
    parent:
      key: 'ObjectId'
      resourceType: 'String'
 
  dal.model name, schema

  crud = dal.crudFactory dal.model(name)

  get = (name, systemId, environmentId, callback) ->
    if not environmentId?
      callback = environmentId
      getSystem name, systemId, callback
    else
      getEnvironment name, systemId, environmentId, callback

  getEnvironment = (name, systemId, environmentId, callback) ->

    environmentsModel.findById environmentId, systemId, (err, environment) ->
      if err
        callback err, null
      if environment and not err
        query =
          key: name
          systemId: systemId
          parent:
            key: environmentId
            resourceType: 'environment'
        crud.findOne query, (err, setting) ->
          if setting and not err
            callback null, setting
          else
       
            #roll up to the system setting
            getSystem name, systemId, callback
      else
        callback "environmentId does not belong to system"

  getSystem = (name, systemId, callback) ->
    query =
      key: name
      systemId: systemId
      parent:
        key: systemId
        resourceType: 'system'
    crud.findOne query, callback


  saveSetting = (setting, newValue, callback) ->
    newSetting:
      _id: setting._id
      key: setting.name
      value: newValue
      systemId: setting.systemId
      parent:
        key: setting.parent.key
        resourceType: setting.parent.resourceType

    crud.update(setting._id, newSetting, callback)

  set = (name, value, systemId, environmentId, callback) ->
    query:
      key: name
      systemId: systemId

    if environmentId?
      parent:
        key: environmentId
        resourceType: 'environment'
    else
      parent:
        key: systemId
        resourcetype: 'system'

    crud.findOne query, (err, setting) ->
      if err
        if not environmentId?
          callback = environmentId
        callback err, null
      
      else if not setting
        newSetting:
          key: name
          value: value
          systemId: systemId

        if environmentId?
          envionmentsModel.findById environmentId, systemId
          , (err, environment) ->
            if environment and not err
              newSetting.parent.key = environmentId
              newSetting.parent.resourceType = 'environment'
              crud.create newSetting, callback
            else
              callback "environmentId does not belong to system"
              , null

        else

          newSetting.parent.key = systemId
          newSetting.parent.resourcetype = 'system'
          crud.create newSetting, callback

      else
        saveSetting setting, value, callback
        
  exports = gint.common.extend {}, crud
  exports.get = get
  exports.set = set
  exports