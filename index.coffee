# ========== Requires ==========
config  = require("./keys")
express = require 'express'
httpserver = express()

request = require 'request'

mailin = require 'mailin'
inmail = require('./inmail')


# ========== Process mail ==========
mailin.start(
  port: 25,
  disableWebhook: true
)

mailin.on('message', inmail.onMessage)