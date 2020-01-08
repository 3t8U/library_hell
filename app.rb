require('sinatra')
require('sinatra/reloader')
require('./lib/album')
require('pry')
require('pg')
also_reload('lib/**/*.rb')

DB = PG.connect(DB_PARAMS)

get('/') do
end
post('/') do
end
patch('/') do
end
delete('/') do
end
