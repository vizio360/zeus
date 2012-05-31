db = require('../dataprovider').db

exports.GET = (req, res, next) ->
  hermesId = req.params.id
  if (hermesId)
      res.send("hermes instance id = "+hermesId)
  else
      next()

exports.PUT = (req, res) ->
    hermesId = req.params.id

    # not sure about this -> current connections
    # max connections
    # ip address
    # port
    # ec2 instance id

    

    #TODO 
    #Get sqlite npm and store data there.
    # if hermes exists
    #      update resource
    # else
    #      insert in DB
