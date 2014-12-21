Database = require './interfaces/database'

Database.query('CREATE TABLE users(id serial PRIMARY KEY, domain varchar(255), slackURL varchar(255), targetEmail varchar(255), passwordDigest varchar(255));', [], (err) ->
  console.error('Error migrating: ' + err) unless err == undefined || err == null
)
