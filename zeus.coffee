express = require('express')
routes = require('./routes')
instances = require('./routes/instances')
hermes = require('./routes/hermes')

app = module.exports = express.createServer()


app.configure ->
    app.set('views', __dirname + '/views')
    app.set('view engine', 'jade')
    app.use(express.bodyParser())
    app.use(express.methodOverride())
    app.use(app.router)
    app.use(express.static(__dirname + '/public'))

app.configure 'development', ->
    app.use(express.errorHandler({ dumpExceptions: true, showStack: true }))

app.configure 'production', ->
    app.use(express.errorHandler())

app.get('/', routes.index)

#app.put('/users/:username?', user.PUT)
#app.get('/users/', users.GET)
#
#

app.put("/hermes/:id", hermes.PUT)
app.get("/hermes/:id?", hermes.GET)
app.get("/hermes/", instances.GET)

app.listen 3000, ->
    console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env)
