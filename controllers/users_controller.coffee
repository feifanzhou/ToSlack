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
      if u != undefined && u!= null && req.cookies.session != undefined && req.cookies.session == u.sessioncode
        res.render('users/show', { user: u})
      else
        res.redirect('/login')
    )
  edit: (req, res) ->
    # TOOD: Need to authenticate request with session cookie
    params = {}
    params['slackURL'] = req.body.slackURL unless req.body.slackURL == undefined
    params['targetEmail'] = req.body.targetEmail unless req.body.targetEmail == undefined
    params['channel'] = req.body.channel unless req.body.channel == undefined
    User.setValues(req.params.id, params, (err) ->
      console.log('Update error: ' + err)
      res.redirect('/users/' + req.params.id)
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
