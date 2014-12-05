bcrypt = require 'bcrypt-nodejs'

class _User
  constructor: (attrs) ->
    @id = attrs.id
    @domain = attrs.domain
    @slackURL = attrs.slackURL
    @targetEmail = attrs.target
    @passwordDigest = bcrypt.hashSync(attrs.password)
    return

  authenticate: (pwdAttempt) ->
    bcrypt.compareSync(pwdAttempt, @passwordDigest)

User = {
  new: (attrs) ->
    new _User(attrs)
}

module.exports = User