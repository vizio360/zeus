sqlite3 = requirer('sqlite3').verbose()

db = new sqlite3.Database 'database/zeus.db'


exports.db = db
