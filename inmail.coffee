config  = require("./keys")

# ========== Utils ==========
sender = (mimeParsedFrom) ->
  firstFrom = if Array.isArray(mimeParsedFrom) then mimeParsedFrom[0] else mimeParsedFrom
  return firstFrom.name || firstFrom.address

postURL = ->
  config.slackURL

# ========== POST to Slack ==========
sendToSlack = (from, message) ->
  payload = {}
  payload.channel = '#general'
  payload.text =  message
  payload.username = from + " (via email)"
  console.log('Posting payload: ' + JSON.stringify(payload) + ' to URL: ' + postURL())
  request.post(
    {
      url: postURL(),
      form: { 'payload': payload },
    },
    (error, response, body) ->
      console.log('Posted email: Response: ' + JSON.stringify(response) + ', error: ' + error)
  )

onMessage = (connection, data, content) ->
  console.log('=================== Received message:')
  console.log('Connection: ' + JSON.stringify(connection))
  console.log('Data: ' + JSON.stringify(data))
  console.log('Content: ' + JSON.stringify(content))
  messageBody = data.text
  from = sender(data.envelopeFrom)
  sendToSlack(from, messageBody)

module.exports.onMessage = onMessage