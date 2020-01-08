require('spec_helper')

describe('#Book') do


  describe('.all') do
    it('return empty array if no entries exist in database') do
      expect(Book.all).to(eq([]))
    end
  end

  describe('#save') do
    it('add book to database') do
      book = Book.new({
        :id => nil,
        :name => 'Catcher',
        :genre => 'Sci-Fi'
      })
      book.save()
      expect(Book.all).to(eq([book]))
    end
  end

  describe('#clean') do
    it('allow for use of apostrophe in SQL tables') do
      book = Book.new({
        :id => nil,
        :name => "Catche'r",
        :genre => 'Sci-Fi'
      })
      book.save()
      expect(Book.all).to(eq([book]))
    end
  end

  describe ('#delete') do
    it('deletes book from database') do
      book = Book.new({
        :id => nil,
        :name => "Catche'r",
        :genre => 'Sci-Fi'
      })
      book.save()
      book.delete
      expect(Book.all).to(eq([]))
    end
  end

  describe ('.find') do
    it('finds a book from database') do
      book = Book.new({
        :id => nil,
        :name => "Catche'r",
        :genre => 'Sci-Fi'
      })
      book.save()
      expect(Book.all.first()).to(eq(Book.find(book.id)))
    end
  end

  describe ('#update') do
    it('updates a book in the database') do
      book = Book.new({
        :id => nil,
        :name => "Catche'r",
        :genre => 'Sci-Fi'
      })
      book.save()
      book.update({
        :name => nil,
        :genre => 'Horror'
      })
      expect(Book.all.first().genre).to(eq('Horror'))
      expect(Book.all.first().name).to(eq("Catche'r"))
    end
  end

  # describe ('#add_author') do
  #   it('adds an author to the book') do
  #     book = Book.new({
  #       :id => nil,
  #       :name => "Catche'r",
  #       :genre => 'Sci-Fi'
  #     })
  #     book.save()
  #     book.add_author()
  #     expect(book.authors()).to(eq(['Hemingway']))
  #   end
  # end

end
