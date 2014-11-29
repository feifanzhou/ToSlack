# ========== Utils ==========
sender = (mimeParsedFrom) ->
  firstFrom = if Array.isArray(mimeParsedFrom) then mimeParsedFrom[0] else mimeParsedFrom
  return firstFrom.name || firstFrom.address

postURL = (subdomain, token) ->
  "https://" + subdomain + ".slack.com/services/hooks/incoming-webhook?token=" + token

# ========== Requires ==========
express = require 'express'
httpserver = express()

request = require 'request'

mailin = require 'mailin'

# ========== POST to Slack ==========
sendToSlack: (from, message) ->
  payload = {}
  payload.channel = '#general'
  payload.text =  message
  payload.username = from + " (via email)"
  request.post(
    postURL(),
    { form: payload },
    (error, response, body) ->
      conosle.log('Posted email: Response: ' + response + ', error: ' + error)
  )


# ========== Process mail ==========
mailin.start(
  port: 25,
  disableWebhook: true
)

mailin.on('message', (connection, data, content) ->
  console.log('=================== Received message:')
  console.log('Connection: ' + JSON.stringify(connection))
  console.log('Data: ' + JSON.stringify(data))
  console.log('Content: ' + JSON.stringify(content))
  messageBody = data.text
  from = sender(data.envelopeFrom)
  sendToSlack(from, messageBody)
)
