sqlite3 = require('sqlite3').verbose()

# global db accessor
db = db or new sqlite3.Database 'database/zeus.db'


exports.db = db
