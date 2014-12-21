# ========== Requires ==========
config  = require("./keys")
express = require 'express'
app = express()
router = express.Router()
cookieParser = require('cookie-parser')
coffeeMiddleware = require('coffee-middleware')
bodyParser = require('body-parser')
sass = require('node-sass')

mailin = require 'mailin'
inmail = require('./inmail')

UsersController = require './controllers/users_controller'

# ========== Process mail ==========
if config.env == 'production'
  mailin.start(
    port: 25,
    disableWebhook: true
  )

  mailin.on('message', inmail.onMessage)

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
router
  .route('/login')
  .get (req, res) ->
    res.render('login')
    return
  .post UsersController.login

router
  .route('/users')
  .post UsersController.create
router
  .route('/users/:id')
  .get UsersController.show
  .post UsersController.edit

# ========== Start server ==========
port = if config.env == 'production' then 80 else 8080
app
  .use(cookieParser())
  .use(bodyParser.json())
  .use(bodyParser.urlencoded({ extended: true }))
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
  .listen(port)
