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
  # DB.exec("ALTER SEQUENCE books_id_sequence RESTART WITH 1;")
  DB.exec("DELETE FROM authors *;")
  # DB.exec("ALTER SEQUENCE authors_id_sequence RESTART WITH 1;")

  redirect to('/books')
end

get('/books') do
  @books = Book.all()
  erb(:books)
end

get('/authors') do
  @authors = Author.all()
  erb(:authors)
end

get ('/books/new') do
  erb(:new_book)
end

get ('/authors/new') do
  erb(:new_author)
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

post ('/authors') do
  name = params[:author_name]
  author = Author.new({:name => name, :id => nil})
  author.save()
  redirect to('/authors')
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

get ('/authors/:id') do
  @author = Author.find(params[:id].to_i())
  erb(:author)
end

get ('/books/:id/edit') do
  @book = Book.find(params[:id].to_i())
  erb(:edit_book)
end

get ('/authors/:id/edit') do
  @author = Author.find(params[:id].to_i())
  erb(:edit_author)
end

patch ('/books/:id') do
  @book = Book.find(params[:id].to_i())
  @book.update({:name => params[:name], :genre => params[:genre]})
  new_author = params[:author_name]
  if (new_author != "")
    author = Author.new({
      :id => nil,
      :name => "#{new_author}"
    })
    author.save()
    @book.add_author(author.name)
  end
  redirect to("/books/#{params[:id]}")
end

patch ('/authors/:id') do
  @author = Author.find(params[:id].to_i())
  @author.update({:name => params[:name]})
  new_book = params[:book_name]
  if (new_book != "")
    book = Book.new({
      :id => nil,
      :name => "#{new_book}",
      :genre => "TBD"
    })
    book.save()
    @author.add_book(book.name)
  end
  redirect to("/authors/#{params[:id]}")
end

delete ('/books/:id') do
  @book = Book.find(params[:id].to_i())
  @book.delete()
  redirect to('/books')
end

delete ('/authors/:id') do
  @author = Author.find(params[:id].to_i())
  @author.delete()
  redirect to('/authors')
end





patch('/') do
end
delete('/') do
end
