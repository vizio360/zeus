hermes = require('../lib/hermes').Hermes

exports.GET = (req, res) ->
  hermesId = req.params.id

  if hermesId?
      hermes.search hermesId, (err, instances) ->
          if (instances.length > 0)
              res.send("hermes instance id = "+hermesId)
          else
              res.send(404)
  else
    result = []
    hermes.list (err, instances) ->
        URI = "/hermes/"
        res.render('hermesList', { layout:'xhtml_layout', title: 'List of hermes(s)', instances: instances , URI: URI})



exports.PUT = (req, res) ->

    #
    # not sure what to send back if
    # for example the request has not got
    # all the fields defined.
    # 409 Conflict?
    # Also, should all the field be required?
    # what if the client wants to update only
    # the ip address?
    # For creation is different as all the fields
    # are mandatory
    #
    #
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

