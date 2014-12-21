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
sendToSlack = (envelopeFrom, message) ->
  payload = {}
  payload.channel = '#general'
  payload.text =  message
  from_name = sender(envelopeFrom)
  payload.username = from_name + " (via email)"
  
  console.log('Posting payload: ' + JSON.stringify(payload) + ' to URL: ' + postURL())
  User.find_by('domain', senderDomain(envelopeFrom), (u, err) ->
    request.post(
      {
        url: u.slackurl,
        form: { 'payload': JSON.stringify(payload) },
      },
      (error, response, body) ->
        console.log('Posted email: Response: ' + JSON.stringify(response) + ', error: ' + error)
    )
  )

onMessage = (connection, data, content) ->
  console.log('=================== Received message:')
  console.log('Connection: ' + JSON.stringify(connection))
  console.log('Data: ' + JSON.stringify(data))
  console.log('Content: ' + JSON.stringify(content))
  messageBody = data.text
  sendToSlack(data.envelopeFrom, messageBody)

module.exports.onMessage = onMessage
