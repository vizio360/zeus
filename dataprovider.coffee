sqlite3 = require('sqlite3').verbose()

# global db accessor
db = new sqlite3.Database 'database/zeus.db'


exports.db = db
