db = require('../dataprovider').db

class Hermes

    tableName: "hermes"

    create: (id, maxConnections, ip, port, ec2Instance, callback) =>
        db.run "INSERT INTO #{@tableName} values(?, ?, ?, ?, ?)", [id, maxConnections, ip, port, ec2Instance], callback
            
    update: (id, maxConnections, ip, port, ec2Instance, callback) =>
        db.run "UPDATE #{@tableName} set maxConnections = ?, ipAddress = ?, port = ?, machineId = ? WHERE id = ?", [update.run maxConnections, ip, port, ec2Instance, id], callback

    list: (callback) =>
        db.all "select * from #{@tableName}", callback

    search: (id, callback) =>
        where = ""
        where = "WHERE id = '#{id}'" if id?
        db.all "select * from #{@tableName} #{where}", callback



# creating a singleton
hermes = hermes or new Hermes()
exports.Hermes = hermes
