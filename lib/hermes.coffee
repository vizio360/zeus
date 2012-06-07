db = require('../dataprovider').db

class Hermes

    create: (id, maxConnections, ip, port, ec2Instance, callback) =>
        insert = db.prepare "INSERT INTO hermes values(?, ?, ?, ?, ?)"
        insert.run id, maxConnections, ip, port, ec2Instance
            
    update: (id, maxConnections, ip, port, ec2Instance, callback) =>
        update = db.prepare "UPDATE hermes set maxConnections = ?, ipAddress = ?, port = ?, machineId = ? WHERE id = ?"
        update.run maxConnections, ip, port, ec2Instance, id

    list: (callback) =>
        db.all "select * from hermes", callback

    search: (id, callback) =>
        where = ""
        where = "WHERE id like '%#{id}%'" if id?
        db.all "select * from hermes #{where}", callback



# creating a singleton
hermes = hermes or new Hermes()
exports.Hermes = hermes
