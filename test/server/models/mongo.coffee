conf = require '../conf'
mongoose = require 'mongoose'

port = parseInt conf.db.port
mongoose.connect conf.db.host, conf.db.name, port