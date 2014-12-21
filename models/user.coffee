bcrypt = require 'bcrypt-nodejs'
Database = require '../interfaces/database'

class _User
  constructor: (attrs) ->
    @id = attrs.id
    @domain = attrs.domain
    @slackURL = attrs.slackURL
    @targetEmail = attrs.target
    @passwordDigest = bcrypt.hashSync(attrs.password)
    @sessionCode = attrs.sessionCode
    return

  _insert: (callback) ->
    newID = User._curr_id + 1
    newSessionCode = (Math.random().toString(36).slice(2)) + (Math.random().toString(36).slice(2)) + (Math.random().toString(36).slice(2))
    q = "INSERT INTO users VALUES (" + newID + ", $1, $2, $3, $4, $5);"
    params = [@domain, @slackURL, @targetEmail, @passwordDigest, newSessionCode]
    self = this
    Database.query(q, params, (err, rows, result) ->
      console.log('Result: ' + JSON.stringify(result))
      User._curr_id = newID
      self.id = newID
      self.sessionCode = newSessionCode
      callback(self, err)
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
      self._curr_id = if rows == undefined || rows.length == 0 then 0 else rows[rows.length - 1]['id']
    )
    return this
  new: (attrs) ->
    new _User(attrs)
  find: (id, callback) ->
    Database.query_first('SELECT * FROM users WHERE id=$1', [id], (err, row, result) ->
      callback(row, err)
    )
  find_by: (attr, val, callback) ->
    Database.query_first('SELECT * FROM users WHERE ' + attr + '=$1;', [val], (err, row, result) ->
      callback(row, err)
    )
  setValues: (id, vals, errorCallback) ->
    setStr = ''
    params = []
    count = 1
    for k,v of vals
      setStr += (k + '=$' + count + ',')
      params.push(v)
      count++
    setStr = setStr.slice(0, -1)
    params.push(id)
    q = 'UPDATE users SET ' + setStr + ' WHERE id=$' + count
    Database.query(q, params, (err, row, result) ->
      errorCallback(err)
    )
}

module.exports = User._init()
