require 'rspec'
require 'pg'
require 'book'
require 'author'
require 'patron'
require 'pry'
require './config'

DB = PG.connect(TEST_DB_PARAMS)

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM books *;")
    DB.exec("DELETE FROM authors *;")
    DB.exec("DELETE FROM authors_books *;")
    DB.exec("DELETE FROM patrons *;")
    DB.exec("DELETE FROM books_patrons *;")
  end
end
