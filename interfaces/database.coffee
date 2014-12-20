pg = require 'pg'
keys = require '../keys'

query = require 'pg-query'
connection = 'postgres://' + keys.pgUserName + ':' + keys.pgPassword + '@' + keys.pgURI + '/' + keys.pgDatabase
#query.connectionParameters = connection
query.connectionParameters = 'postgres://Feifan@localhost/toslack'

Database = {
  _client: undefined
  _is_connected: false
  _connect: ->
    pg.connect(connection, ((err, client, done) ->
      if (err)
        return console.error('error fetching client from pool', err);
      @_is_connected = true
      @_client = client
    ).bind(this))
  find: (table, id, callback) ->
    @find_by(table, 'id', id, callback)
  find_by: (table, attr, value, callback) ->
    @_client.query({
      name: 'find_by'
      text: 'SELECT * FROM $1 WHERE $2=$3 LIMIT 1'
      text:'SELECT * FROM ' + table + ' WHERE ' + attr + '=' + value + ' LIMIT 1'
      values:[123]
    })
  query: (q, vals, callback) ->
    query(q, vals, callback)
  query_first: (q, vals, callback) ->
    query.first(q, vals, callback)
}

module.exports = Database
