bcrypt = require 'bcrypt-nodejs'
Database = require '../interfaces/database'

class _User
  constructor: (attrs) ->
    @id = attrs.id
    @domain = attrs.domain
    @slackURL = attrs.slackURL
    @targetEmail = attrs.target
    @passwordDigest = bcrypt.hashSync(attrs.password)
    return

  _insert: (callback) ->
    q = "INSERT INTO users VALUES (DEFAULT, $1, $2, $3, $4);"
    params = [@domain, @slackURL, @targetEMail, @passwordDigest]
    self = this
    Database.query(q, params, (err, rows, result) ->
      console.log('Result: ' + JSON.stringify(result))
      self.id = result.id  # FIX access to ID (probably)
      callback(self)
    )

  _update: ->
    # Update

  authenticate: (pwdAttempt) ->
    bcrypt.compareSync(pwdAttempt, @passwordDigest)

  save: (callback) ->
    if @id == undefined
      @_insert(callback)
    else
      @_update(callback)

User = {
  _table: 'users'
  new: (attrs) ->
    new _User(attrs)
  find_by: (attr, val, callback) ->
    #Database.find_by(@_table, attr, val, callback)
    Database.query('SELECT * FROM ' + @_table + ' WHERE $1=$2;', [attr, val], callback)
}

module.exports = User
