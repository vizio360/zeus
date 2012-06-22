db = require('../dataprovider').db

class Machine

    tableName: "machine"

    create: (id, ip, privateIp, type) =>
        insert = db.prepare "INSERT INTO #{@tableName}(id, ip, privateIp, type) values(?, ?, ?, ?)"
        insert.run id, ip, privateIp, type
            
    update: (id, ip, privateIp, type) =>
        update = db.prepare "UPDATE #{@tableName} set ip = ?, privateIp = ?, type = ? WHERE id = ?"
        update.run ip, privateIp, type, id

    list: (callback) =>
        db.all "select * from #{@tableName}", callback

    search: (id, callback) =>
        where = ""
        where = "WHERE id = '#{id}'" if id?
        db.all "select * from #{@tableName} #{where}", callback



# creating a singleton
machine = machine or new Machine()
exports.Machine = machine
