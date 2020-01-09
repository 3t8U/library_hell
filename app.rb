require('sinatra')
require('sinatra/reloader')
require('./lib/book')
require('./lib/author')
require('./lib/patron')
require('pry')
require('pg')
also_reload('lib/**/*.rb')
require './config'

DB = PG.connect(DB_PARAMS)

get('/') do
  erb(:home)
end

get('/purge') do
  DB.exec("DELETE FROM books *;")
  redirect to('/books')
end

get('/books') do
  @books = Book.all()
  erb(:books)
end

get('/author') do
  @authors = Author.all()
  erb(:authors)
end

get ('/books/new') do
  erb(:new_book)
end

post ('/books') do
  name = params[:book_name]
  genre = params[:genre]
  author = params[:author]
  book = Book.new({:name => name, :id => nil, :genre => genre})
  book.save()
  if author != ''
    book.add_author(author)
  end
  redirect to('/books')
end

post('/books/search') do
  name = params[:name]
  genre = params[:genre]
  @query = "#{(name != '') ? ('Name: ' + name) : ''}#{(genre != '') ? (((name != '') ? ', ' : '') + 'Genre: ' + genre) : ''}"
  @books = Book.search({:name => name, :genre => genre})
  erb(:search)
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
