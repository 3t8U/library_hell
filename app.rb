require('sinatra')
require('sinatra/reloader')
require('./lib/book')
require('pry')
require('pg')
also_reload('lib/**/*.rb')

DB = PG.connect(DB_PARAMS)

get('/') do
  redirect to ('/books')
end

get ('/books/new') do
  erb(:new_book)
end

post ('/books') do
  name = params[:book_name]
  book = Book.new({:name => name, :id => nil, :genre => genre})
  book.save()
  redirect to('/books')
end

get ('/books/:id') do
  @book = Book.find(params[:id].to_i())
  erb(:book)
end

get ('/books/:id/edit') do
  @book = Book.find(params[:id].to_i())
  erb(:edit_book)
end

patch ('/books/:id') do
  @book = Book.find(params[:id].to_i())
  @book.update({:name => params[:name], :author_name => params[:author_name]})
  redirect to('')
end





patch('/') do
end
delete('/') do
end
