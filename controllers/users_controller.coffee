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
      #console.log('u: ' + JSON.stringify(u))
      if req.cookies.session == undefined || req.cookies.session != u.sessioncode
        res.redirect('/login')
      else
        res.send('<p>' + u.id + '</p>')
    )
}

module.exports = UsersController
