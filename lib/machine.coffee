db = require('../dataprovider').db

class Machine

    tableName: "machine"

    create: (id, ip, type) =>
        insert = db.prepare "INSERT INTO #{@tableName} values(?, ?, ?)"
        insert.run id, ip, type
            
    update: (id, ip, type) =>
        update = db.prepare "UPDATE #{@tableName} set ip = ?, type = ? WHERE id = ?"
        update.run ip, type, id

    list: (callback) =>
        db.all "select * from #{@tableName}", callback

    search: (id, callback) =>
        where = ""
        where = "WHERE id = '#{id}'" if id?
        db.all "select * from #{@tableName} #{where}", callback



# creating a singleton
machine = machine or new Machine()
exports.Machine = machine
