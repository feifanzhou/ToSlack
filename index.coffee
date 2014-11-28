express = require 'express'
httpserver = express()

mailin = require 'mailin'

mailin.start(
  port: 25,
  disableWebhook: true
)

mailin.on('message', (connection, data, content) ->
          console.log('Connection: ' + JSON.stringify(connection))
          console.log('Data: ' + JSON.stringify(data))
          console.log('Content: ' + JSON.stringify(content))
)
