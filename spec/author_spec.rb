require('spec_helper')


describe('#Author') do

  describe('.all') do
    it('return empty array if no entries exist in database') do
      expect(Author.all).to(eq([]))
    end
  end

  describe('#save') do
    it('adds an author to the database') do
      author = Author.new({
        :id => nil,
        :name => 'Hemingway'
      })
      author.save()
      expect(Author.all).to(eq([author]))
    end
  end

  describe('#clean') do
    it('allow for use of apostrophe in SQL tables') do
      author = Author.new({
        :id => nil,
        :name => "O'hara"
      })
      author.save()
      expect(Author.all).to(eq([author]))
    end
  end

  describe ('#delete') do
    it('deletes author from database') do
      author = Author.new({
        :id => nil,
        :name => "O'hara"
      })
      author.save()
      author.delete()
      expect(Author.all).to(eq([]))
    end
  end

  describe ('.find') do
    it('finds an author from the database') do
      author = Author.new({
        :id => nil,
        :name => "O'hara"
      })
      author.save()
      expect(Author.all.first()).to(eq(Author.find(author.id)))
    end
  end

  describe ('.search') do
    it('finds an author from the database') do
      author = Author.new({
        :id => nil,
        :name => "O'hara"
      })
      author.save()
      expect(Author.all.first()).to(eq(Author.search(author.name)))
    end
  end

  describe ('#update') do
    it('updates a book in the database') do
      author = Author.new({
        :id => nil,
        :name => "O'hara"
      })
      author.save()
      author.update({
        :name => 'Billy'
      })
      expect(Author.all.first().name).to(eq('Billy'))
    end
  end

  describe ('#add_book') do
    it('adds a book to the author') do
      book = Book.new({
        :id => nil,
        :name => "Catche'r",
        :genre => 'Sci-Fi'
      })
      book.save()
      author = Author.new({
        :id => nil,
        :name => "O'hara"
      })
      author.save()
      author.add_book("Catche'r")
      expect(author.books()).to(eq([book]))
    end
  end

end
