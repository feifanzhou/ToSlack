# ========== Requires ==========
config  = require("./keys")
express = require 'express'
app = express()
router = express.Router()
coffeeMiddleware = require('coffee-middleware')
sass = require('node-sass')

request = require 'request'

mailin = require 'mailin'
inmail = require('./inmail')


# ========== Process mail ==========
# mailin.start(
#   port: 25,
#   disableWebhook: true
# )

# mailin.on('message', inmail.onMessage)

# ========== Set up routes ==========
router
  .route('/')
  .get (req, res) ->
    res.render('index', { page: 'index' })
    return

router
  .route('/signup')
  .get (req, res) ->
    res.render('signup', { domain: req.query.d })
    return


# ========== Start server ==========
app
  .use('/', router)
  # .use(coffeeMiddleware({
  #   src: __dirname + '/views/pages'
  #   compress: true
  # }))
  .use(sass.middleware({
    src: __dirname + '/assets/stylesheets'
    dest: __dirname + '/public'
    debug: true
    outputStyle: 'nested'
  }))
  .use(express.static(__dirname + '/public'))
  .set('views', './views')
  .set('view engine', 'ejs')
  .listen(8080)