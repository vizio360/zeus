db = require('../dataprovider').db

class Machine

    tableName: "machine"

    create: (id, ip, privateIp, type, callback) =>
        db.run "INSERT INTO #{@tableName}(id, ip, privateIp, type) values(?, ?, ?, ?)", [id, ip, privateIp, type], callback
            
    update: (id, ip, privateIp, type, callback) =>
        db.run "UPDATE #{@tableName} set ip = ?, privateIp = ?, type = ? WHERE id = ?", [ip, privateIp, type, id], callback

    list: (callback) =>
        db.all "select * from #{@tableName}", callback

    search: (id, callback) =>
        where = ""
        where = "WHERE id = '#{id}'" if id?
        db.all "select * from #{@tableName} #{where}", callback

    delete: (id, callback) =>
        db.run "DELETE FROM #{@tableName} WHERE id = ?", [id], callback


# creating a singleton
machine = machine or new Machine()
exports.Machine = machine
