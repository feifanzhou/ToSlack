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
}

module.exports = UsersController
