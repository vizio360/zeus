os = require 'os'
machine = require('../../lib/machine').Machine
models = require('./models')
swagger = require('../../subtrees/swagger/Common/node/swagger.js')
apiConfig = require('../config')
# FIXME
# this shouldn't be in this file
execFile = require('child_process').execFile
apiConfig = require('../config')


exports.getMachineById = {
        'spec': {
            "description": "Get machine details",
            "path": "/machine/{id}",
            "method": "GET",
            "notes": "blah blah",
            "summary": "find a machine by id",
            "params": new Array(
                    swagger.pathParam("id", "ID of machine that needs to be fetched", "string")
                ),
            "outputModel": {
                "name": "machine",
                "responseClass": models.machine
                },
            "errorResponses": new Array(
                swagger.error(400, "invalid id"),
                swagger.error(404, "Machine not found")
                ),
            "nickname": "getMachineById"
        },
        'action': (req,res) ->
            machineId = req.params.id
            if machineId?
                machine.search machineId, (err, instances) =>
                    if (instances.length > 0)
                        machineDetails = instances[0]
                        details =
                            id: machineDetails.id
                            ip: machineDetails.ip
                            type: machineDetails.type

                        res.send(JSON.stringify(swagger.containerByModel(models.machine, details)))
                    else
                        res.send(404, JSON.stringify({ "message": "Machine not found" }))

    }


exports.getAllMachines = {
        'spec': {
            "description": "Get all machines",
            "path": "/machine/",
            "method": "GET",
            "notes": "blah blah",
            "summary": "Gets the list of all the machines registered",
            "params": new Array(),
            "outputModel": {
                "name": "machineList",
                "responseClass": models.machineList
                },
            "errorResponses": new Array(
                swagger.error(500, "some very wrong happened"),
                ),
            "nickname": "getMachineList"
        },
        'action': (req,res) ->
            result = []
            machine.list (err, instances) =>
                URI = apiConfig.basePath+"/machine/"
                data = []
                for i in instances
                    pp ={}
                    pp.id = i.id
                    pp.link = URI+i.id
                    data.push pp
                res.send(JSON.stringify(swagger.containerByModel(models.machineList, { "machines":data }, false)))
    }



exports.putMachine = {
        'spec': {
            "description": "Creates or updates a machine",
            "path": "/machine/{id}",
            "method": "PUT",
            "notes": "blah blah",
            "summary": "Creates or updates a machine",
            "params": new Array(
                    swagger.pathParam("id", "ID of the machine to create or update", "string"),
                    swagger.postParam("Ip address of the machine", "string"),
                    swagger.postParam("Type of the machine", "string"),
                ),
            "errorResponses": new Array(
                swagger.error(500, "something wrong happened!"),
                ),
            "nickname": "AddUpdateMachineInstance"
        },
        'action': (req,res) ->

            machineId = req.params.id
            ip = req.body.ip
            type = req.body.type
            privateIp = req.body.privateIp

            machine.search machineId, (err, instances) ->

                if (instances.length > 0)
                    machine.update machineId, ip, privateIp, type
                    res.send(200)
                else
                    # TODO
                    # expect internal ip from instance
                    # create the munin config file in /etc/munin/munin-conf.d/<name>
                    command = "echo \"[#{machineId}]\n   address #{privateIp}\n   use_node_name yes\n\" | sudo tee -a /etc/munin/munin-conf.d/#{machineId}"
                    exec command, (error, stdout, stderr) =>
                        if error?
                            console.log "could not create munin conf file for node"
                            res.send(500)
                            return
                        machine.create machineId, ip, privateIp, type, (err) =>
                            res.send(201)
    }

exports.postMachineCreate = {
        'spec': {
            "description": "Starts the procedure to create a new Amazon Ec2 machine",
            "path": "/machine/create/",
            "method": "POST",
            "notes": "blah blah",
            "summary": "Creates new Amazon Ec2 machine",
            "params": new Array(
                    swagger.postParam("Amazon EC2 instance type", "string"),
                    swagger.postParam("Number of Hermes Instances to install", "int"),
                    swagger.postParam("Amazon Image Id to use", "string")
                ),
            "errorResponses": new Array(
                swagger.error(500, "something wrong happened!"),
                ),
            "nickname": "AmazonEc2MachineManager"
        },
        'action': (req,res) ->

            instanceType = req.body.instanceType
            hermesCount = req.body.hermesCount
            imageId = req.body.imageId


            attr =
                zeus:
                    endPoint: "#{apiConfig.basePath}"
                    internalIp: "#{apiConfig.internalDNS}"
                amazon:
                    meta_data_ws: "#{apiConfig.amazon_ws}"
                hermes:
                    number_of_instances: hermesCount

            args = ["#{instanceType}", "#{imageId}", "'"+JSON.stringify(attr)+"'"]

            execFile apiConfig.createMachineScript, args ,(error, stdout, stderr) =>
                if error?
                    console.log "Error while running knife to create machine"
                    console.log "stdout", stdout
                    console.log "stderr", stderr
                    return
                console.log "Successfully created machine"
                console.log "stdout", stdout

            res.send(202)
    }


exports.postMachineDelete = {
        'spec': {
            "description": "Starts the procedure to delete a Amazon Ec2 machine",
            "path": "/machine/delete/",
            "method": "POST",
            "notes": "blah blah",
            "summary": "Deletes Amazon Ec2 machine",
            "params": new Array(
                    swagger.postParam("Amazon EC2 instance id", "string"),
                ),
            "errorResponses": new Array(
                swagger.error(500, "something wrong happened!"),
                ),
            "nickname": "AmazonEc2MachineDelete"
        },

        'action': (req,res) ->

            instanceId = req.body.instanceId

            args = ["#{instanceId}"]

            execFile apiConfig.deleteMachineScript, args, (error, stdout, stderr) =>
                if error?
                    console.log "Error while running knife to delete a node"
                    console.log "stderr", stderr
                    return
                console.log "Successfully deleted node #{instanceId}"

            # TODO
            # maybe I should map this one to a DELETE
            machine.delete instanceId, (err) =>
                if err?
                    console.log "An error occured while deleting #{instanceId} machine"
                    res.send(500)
                    return
                res.send(202)
    }
