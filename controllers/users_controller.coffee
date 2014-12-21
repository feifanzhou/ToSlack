User = require '../models/user'
bcrypt = require 'bcrypt-nodejs'

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
      if req.cookies.session == undefined || req.cookies.session != u.sessioncode
        res.redirect('/login')
      else
        res.send('<p>' + u.id + '</p>')
    )
  login: (req, res) ->
    User.find_by('domain', req.body.domain, (u, err) ->
      if u != undefined && bcrypt.compareSync(req.body.password, u.passworddigest)
        oneYear = new Date()
        oneYear.setYear(oneYear.getFullYear() + 1)
        res.cookie('session', u.sessioncode, { expires: oneYear })
        res.redirect('/users/' + u.id)
      else
        res.redirect('/')  # FIXME: Add detailed error
    )
}

module.exports = UsersController
