User = require '../models/user'

UsersController = {
  create: (req, res) ->
    u = User.new({
      domain: req.body.domain
      slackURL: req.body.slackURL
      target: req.body.target
      password: req.body.password
    })
    u.save((u, err) ->
      oneYear = new Date()
      oneYear.setYear(oneYear.getFullYear() + 1)
      res.cookie('session', u.sessionCode, { expires: oneYear })
      res.redirect('/users/' + u.id)
    )
  show: (req, res) ->
    User.find(req.params.id, (u, err) ->
      res.send('<p>' + u.id + '</p>')
    )
}

module.exports = UsersController
