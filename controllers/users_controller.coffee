User = require '../models/user'

UsersController = {
  create: (req, res) ->
    u = User.new({
      domain: req.body.domain
      slackURL: req.body.slackURL
      target: req.body.target
      password: req.body.password
    })
    u.save((u) ->
      res.redirect('/users/' + u.id)
    )
  show: (req, res) ->
    User.find(req.params.id, (u, err) ->
      res.send('<p>' + u.id + '</p>')
    )
}

module.exports = UsersController
