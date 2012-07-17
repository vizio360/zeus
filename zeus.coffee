os = require 'os'
express = require('express')
routes = require('./routes')
hermes = require('./routes/hermesAPI')
http = require('http')
swagger = require('./subtrees/swagger/Common/node/swagger.js')
apiConfig = require('./api/config')
rest = require('restler')
async = require('async')
commander = require('commander')

commander.option('--noAmazonMetaData', 'avoid getting meta data for the machine from Amazon').parse(process.argv)

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

getInfo= (endPoint, callback) =>
    if commander.noAmazonMetaData?
        callback(null, "")
        return
    rest.get(endPoint).on 'complete', (result) =>
        if result instanceof Error
            console.log "an error occured while getting #{endPoint} from amazon"
            console.log result
            callback(result)
            return
        callback(null, result)

data =
    privateIp:async.apply(getInfo, apiConfig.amazon_ws + 'local-ipv4')
    dns: async.apply(getInfo, apiConfig.amazon_ws + 'public-hostname')



async.parallel data, (err, results) =>
    if err?
        console.log "something went wrong while startig zeus"
        console.log err
        return

    if results.dns == "" and results.privateIp == ""
        results.dns = "localhost"
        results.privateIp = "127.0.0.1"

    apiConfig.basePath = "http://#{results.dns}:#{app.get('port')}"
    swagger.setAppHandler app

    swagger.discover(require("./api/hermes/resources"))
    swagger.discover(require("./api/machine/resources"))
    swagger.configure(apiConfig.basePath, "0.1")

    apiConfig.internalIp = results.privateIp
    http.createServer(app).listen app.get('port'), () ->
        console.log("Express server listening on port " + app.get('port'))


