db = require('../dataprovider').db

class Hermes

    tableName: "hermes"

    create: (id, maxConnections, ip, port, ec2Instance, callback) =>
        insert = db.prepare "INSERT INTO #{@tableName} values(?, ?, ?, ?, ?)"
        insert.run id, maxConnections, ip, port, ec2Instance
            
    update: (id, maxConnections, ip, port, ec2Instance, callback) =>
        update = db.prepare "UPDATE #{@tableName} set maxConnections = ?, ipAddress = ?, port = ?, machineId = ? WHERE id = ?"
        update.run maxConnections, ip, port, ec2Instance, id

    list: (callback) =>
        db.all "select * from #{@tableName}", callback

    search: (id, callback) =>
        where = ""
        where = "WHERE id = '#{id}'" if id?
        db.all "select * from #{@tableName} #{where}", callback



# creating a singleton
hermes = hermes or new Hermes()
exports.Hermes = hermes
