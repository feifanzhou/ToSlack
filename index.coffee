# ========== Utils ==========
sender = (mimeParsedFrom) ->
  firstFrom = Array.isArray(mimeParsedFrom) ? mimeParsedFrom[0] : mimeParsedFrom
  return firstFrom.name || firstFrom.address

# ========== Requires ==========
express = require 'express'
httpserver = express()

request = require 'request'

mailin = require 'mailin'

# ========== POST to Slack ==========
sendToSlack: (from, message) ->


# ========== Process mail ==========
mailin.start(
  port: 25,
  disableWebhook: true
)

mailin.on('message', (connection, data, content) ->
          messageBody = data.text
          from = sender(data.envelopeFrom)
          sendToSlack(from, messageBody)
)
