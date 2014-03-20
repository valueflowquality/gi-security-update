AWS = require 'aws-sdk'
_ = require 'underscore'
gi = require 'gi-util'

module.exports = (models, crudControllerFactory) ->
  crudController  = crudControllerFactory(models.files)
  settings = models.settings

  updatePrimary = (file, res) ->
    if file.primary
      #TODO: set all other files with this parent to primary = false
      res.json 200, file
    else
      res.json 200, file

  create = (req, res) ->
    crudController.create req, res, () ->
      updatePrimary res.giResult, res

  update = (req, res) ->
    crudController.update req, res, () ->
      updatePrimary res.giResult, res

  destroy = (req, res) ->
    settings.get "awsAccessKey"
    , req.systemId, req.environmentId, (err, awsKey) ->
      if err
        res.json 404, "AWS Access key not set"
      else
        settings.get "awsBucketName"
        , req.systemId, req.environmentId, (err, awsBucket) ->
          if err
            res.json 404, "AWS bucket name not set"
          else
            settings.get "awsSecretKey"
            , req.systemId, req.environmentId, (err, awsSecret) ->
              if err
                res.json 404, "AWS secret key not set"
              else
                if req.params?.id
                  models.files.findById req.params.id, req.systemId
                  , (err, file) ->
                    if err or (not file)
                      res.json 404, "could not find file with that id"
                    else
                      #let's go and delete the files from S3
                      awsConfig =
                        accessKeyId: awsKey.value
                        secretAccessKey: awsSecret.value
                      
                      AWS.config.update awsConfig

                      s3 = new AWS.S3()

                      path = 'public/images/' + file.parentType + '/' +
                      file.parentId + '/'

                      deleteParams =
                        Bucket: awsBucket.value
                        Delete:
                          Objects: [ Key: path + file.name]

                      _.each file.s3alternates, (alternate) ->
                        obj = { Key: path + alternate + file.name }
                        deleteParams.Delete.Objects.push obj

                      s3.deleteObjects deleteParams, (err, data) ->
                        crudController.destroy req, res
      
                else
                  res.json 404, "could not find file with that id"
  
  exports = gi.common.extend {}, crudController
  exports.create = create
  exports.destroy = destroy
  exports