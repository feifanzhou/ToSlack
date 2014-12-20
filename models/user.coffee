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
    newID = User._curr_id + 1
    q = "INSERT INTO users VALUES (" + newID + ", $1, $2, $3, $4);"
    params = [@domain, @slackURL, @targetEmail, @passwordDigest]
    self = this
    Database.query(q, params, (err, rows, result) ->
      console.log('Result: ' + JSON.stringify(result))
      User._curr_id = newID
      self.id = newID
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
  _curr_id: undefined
  _init: ->
    self = this
    Database.query('SELECT id FROM users', [], (err, rows, result) ->
      self._curr_id = rows[rows.length - 1]['id']
    )
    return this
  new: (attrs) ->
    new _User(attrs)
  find: (id, callback) ->
    Database.query_first('SELECT * FROM users WHERE id=$1', [id], (err, row, result) ->
      console.log('Row: ' + JSON.stringify(row))
      callback(row, err)
    )
  find_by: (attr, val, callback) ->
    #Database.find_by(@_table, attr, val, callback)
    Database.query('SELECT * FROM ' + @_table + ' WHERE $1=$2;', [attr, val], callback)
}

module.exports = User._init()
