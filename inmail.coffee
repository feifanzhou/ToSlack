config  = require("./keys")
User = require './models/user'

request = require 'request'

# ========== Utils ==========
sender = (mimeParsedFrom) ->
  firstFrom = if Array.isArray(mimeParsedFrom) then mimeParsedFrom[0] else mimeParsedFrom
  return firstFrom.name || firstFrom.address
senderDomain = (mimeParsedFrom) ->
  firstFrom = if Array.isArray(mimeParsedFrom) then mimeParsedFrom[0] else mimeParsedFrom
  address = firstFrom.address
  posOfAt = address.indexOf('@')
  if posOfAt < 0 then return undefined else return address.substring(posOfAt + 1)

postURL = ->
  config.slackURL

# ========== POST to Slack ==========
attemptPost = (url, payload, count) ->
  try
    request.post(
      {
        url: url,
        form: { 'payload': JSON.stringify(payload) }
      },
      (error, response, body) ->
        console.log('Posted email: Response: ' + JSON.stringify(response) + ', error: ' + error)
    )
  catch error
    console.log('Error posting to Slack: ' + error)
    attemptPost(url, payload) if count < 5
sendToSlack = (envelopeFrom, message) ->
  payload = {}
  payload.text =  message
  from_name = sender(envelopeFrom)
  payload.username = from_name + " (via email)"
  
  User.find_by('domain', senderDomain(envelopeFrom), (u, err) ->
    payload.channel = u.channel
    attemptPost(u.slackurl, payload, 1)
  )

onMessage = (connection, data, content) ->
  console.log('=================== Received message:')
  console.log('Connection: ' + JSON.stringify(connection))
  console.log('Data: ' + JSON.stringify(data))
  console.log('Content: ' + JSON.stringify(content))
  messageBody = data.text
  sendToSlack(data.envelopeFrom, messageBody)

module.exports.onMessage = onMessage
