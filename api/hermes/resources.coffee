hermes = require('../../lib/hermes').Hermes
models = require('./models')
swagger = require('../../subtrees/swagger/Common/node/swagger.js')
apiConfig = require('../config')


exports.getInstanceById = {
        'spec': {
            "description": "Get hermes instance details",
            "path": "/hermes/{id}",
            "method": "GET",
            "notes": "blah blah",
            "summary": "find a Hermes instance by id",
            "params": new Array(
                    swagger.pathParam("id", "ID of hermes that needs to be fetched", "string")
                ),
            "outputModel": {
                "name": "hermes",
                "responseClass": models.hermes
                },
            "errorResponses": new Array(
                swagger.error(400, "invalid id"),
                swagger.error(404, "Pet not found")
                ),
            "nickname": "getHermesById"
        },
        'action': (req,res) ->
            console.log "find by id"
            hermesId = req.params.id
            if hermesId?
                hermes.search hermesId, (err, instances) =>
                    if (instances.length > 0)
                        hermesDetails = instances[0]
                        details =
                            id: hermesDetails.id
                            maxConnections: hermesDetails.maxConnections
                            ip: hermesDetails.ipAddress
                            port: hermesDetails.port
                            machineId: hermesDetails.machineId


                        res.send(JSON.stringify(swagger.containerByModel(models.hermes, details, false)))
                    else
                        res.send(404, JSON.stringify({ "message": "Instance not found" }))

    }


exports.getAllInstances = {
        'spec': {
            "description": "Get all hermes instances",
            "path": "/hermes/",
            "method": "GET",
            "notes": "blah blah",
            "summary": "Gets the list of all the hermes instances registered",
            "params": new Array(),
            "outputModel": {
                "name": "hermesList",
                "responseClass": models.hermesList
                },
            "errorResponses": new Array(
                swagger.error(500, "some very wrong happened"),
                ),
            "nickname": "getHermesList"
        },
        'action': (req,res) ->
            result = []
            hermes.list (err, instances) =>
                URI = apiConfig.basePath+"/hermes/"
                data = []
                for i in instances
                    pp ={}
                    pp.id = i.id
                    pp.link = URI+i.id
                    data.push pp
                res.send(JSON.stringify(swagger.containerByModel(models.hermesList, { "instances":data }, false)))
    }



exports.putInstance = {
        'spec': {
            "description": "Creates or updates a hermes instance",
            "path": "/hermes/{id}",
            "method": "PUT",
            "notes": "blah blah",
            "summary": "Creates or updates a hermes instance",
            "params": new Array(
                    swagger.pathParam("id", "ID of hermes to create or update", "string"),
                    swagger.postParam("Number of maximum concurrent connections for this instance", "int"),
                    swagger.postParam("IP address of the hermes instance", "string"),
                    swagger.postParam("Port to which hermes will listent to", "int"),
                    swagger.postParam("Id of the amazon EC2 machine where the hermes instance live", "string"),
                ),
            "errorResponses": new Array(
                swagger.error(500, "something wrong happened!"),
                ),
            "nickname": "AddUpdateHermesInstance"
        },
        'action': (req,res) ->

            hermesId = req.params.id
            maxConnections = req.body.maxConnections
            ip = req.body.ip
            port = req.body.port
            machineId = req.body.machineId

            hermes.search hermesId, (err, instances) ->

                if (instances.length > 0)
                    hermes.update hermesId, maxConnections, ip, port, machineId
                    res.send(200)
                else
                    hermes.create hermesId, maxConnections, ip, port, machineId
                    res.send(201)
    }
