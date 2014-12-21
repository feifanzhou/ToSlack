Database = require './interfaces/database'

Database.query('CREATE TABLE users(id serial PRIMARY KEY, domain varchar(255), slackURL varchar(255), targetEmail varchar(255), passwordDigest varchar(255));', [], (err) ->
  console.error('Error migrating: ' + err) unless err == undefined || err == null
)
Database.query('ALTER TABLE users ADD COLUMN sessionCode varchar(255)', [], (err) ->
  console.log('Error migrating: ' + err) unless err == undefined || err == null
)
Database.query("ALTER TABLE users ADD COLUMN channel varchar(255) DEFAULT '#general'", [], (err) ->
  console.log('Error migrating: ' + err) unless err == undefined || err == null
)
