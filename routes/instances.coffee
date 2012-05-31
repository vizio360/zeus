db = require('../dataprovider').db

exports.GET = (req, res) ->
    result = ""
    db.all 'select * from hermes_instances_HRI', (err, rows) ->
        result += row.id_HRI for row in rows
        res.send("list of hermeses registered<br>"+result)

