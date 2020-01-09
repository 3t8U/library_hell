# require('rspec')
# require('app')
#
# require('spec_helper')
# require('capybara')
# #


require('pg')
require('capybara/rspec')
require('./app')
Capybara.app = Sinatra::Application
set(:show_exceptions, false)
require 'spec_helper'

describe('create an book path', {:type => :feature}) do
  it('creates an book and then goes to the book page') do
    visit('/books')
    click_on('Add a book!')
    fill_in('book_name', :with => 'Yellow Submarine')
    click_on('Add book')
    expect(page).to have_content('Yellow Submarine')
  end
end

describe('create a author path', {:type => :feature}) do
  it('creates an book and then goes to the book page') do
    author = Author.new({:name => "Yellow Submarine", :id => nil})
    author.save
    visit("/authors")
    click_on('Add an Author!')
    fill_in('author_name', :with => 'Salty Sally')
    click_on('Add Author')
    expect(page).to have_content('Salty Sally')
  end
end



# describe('#Integration') do
#   before(:each) do
#   end
#   describe('#') do
#     it('') do
#       expect().to(eq())
#     end
#   end
# end
