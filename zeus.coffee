os = require 'os'
express = require('express')
routes = require('./routes')
hermes = require('./routes/hermesAPI')
http = require('http')
swagger = require('./subtrees/swagger/Common/node/swagger.js')
apiConfig = require('./api/config')
rest = require('restler')


app = express()


app.configure ->
    app.set('port', process.env.PORT || 3000)
    app.set('views', __dirname + '/views')
    app.set('view engine', 'jade')
    app.use(express.favicon())
    app.use(express.logger('dev'))
    app.use(express.bodyParser())
    app.use(express.methodOverride())
    app.use(app.router)
    app.use(express.static(__dirname + '/public'))

app.configure 'development', ->
    app.use(express.errorHandler({ dumpExceptions: true, showStack: true }))

app.configure 'production', ->
    app.use(express.errorHandler())


apiConfig.basePath = "http://#{os.hostname()}:#{app.get('port')}"
swagger.setAppHandler app

swagger.discover(require("./api/hermes/resources"))
swagger.discover(require("./api/machine/resources"))
swagger.configure(apiConfig.basePath, "0.1")

rest.get(apiConfig.amazon_ws+"local-hostname").on "complete", (result) =>
    if result instanceof Error
        console.log "an error occured while getting the internal DNS from amazon"
        console.log result
        return
    apiConfig.internalDNS = result
    http.createServer(app).listen app.get('port'), () ->
        console.log("Express server listening on port " + app.get('port'))


