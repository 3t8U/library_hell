require('spec_helper')


describe('#Patron') do

  describe('.all') do
    it('return empty array if no entries exist in database') do
      expect(Patron.all).to(eq([]))
    end
  end

  describe('#save') do
    it('adds an patron to the database') do
      patron = Patron.new({
        :id => nil,
        :name => 'Hemingway'
      })
      patron.save()
      expect(Patron.all).to(eq([patron]))
    end
  end

  describe('#clean') do
    it('allow for use of apostrophe in SQL tables') do
      patron = Patron.new({
        :id => nil,
        :name => "O'hara"
      })
      patron.save()
      expect(Patron.all).to(eq([patron]))
    end
  end

  describe ('#delete') do
    it('deletes patron from database') do
      patron = Patron.new({
        :id => nil,
        :name => "O'hara"
      })
      patron.save()
      patron.delete()
      expect(Patron.all).to(eq([]))
    end
  end

  describe ('.find') do
    it('finds an patron from the database') do
      patron = Patron.new({
        :id => nil,
        :name => "O'hara"
      })
      patron.save()
      expect(Patron.all.first()).to(eq(Patron.find(patron.id)))
    end
  end

  describe ('#update') do
    it('updates a book in the database') do
      patron = Patron.new({
        :id => nil,
        :name => "O'hara"
      })
      patron.save()
      patron.update({
        :name => 'Billy'
      })
      expect(Patron.all.first().name).to(eq('Billy'))
    end
  end

  describe ('#add_book') do
    it('adds a book to the patron') do
      book = Book.new({
        :id => nil,
        :name => "Catche'r",
        :genre => 'Sci-Fi'
      })
      book.save()
      patron = Patron.new({
        :id => nil,
        :name => "O'hara"
      })
      patron.save()
      patron.add_book("Catche'r")
      expect(patron.books()).to(eq([book]))
      expect(
        DateTime.parse(DB.exec("SELECT * FROM books_patrons WHERE patron_id = #{patron.id}").first().fetch("due_date"))
      ).to(eq(DateTime.parse("#{(Time.now + Book.lend_time)}".slice(0..18))))
    end
  end

  describe ('#return_book') do
    it('adds a book to the patron') do
      book = Book.new({
        :id => nil,
        :name => "Catche'r",
        :genre => 'Sci-Fi'
      })
      book.save()
      patron = Patron.new({
        :id => nil,
        :name => "O'hara"
      })
      patron.save()
      patron.add_book("Catche'r")
      expect(patron.books()).to(eq([book]))
      patron.return_book(book.id)
      expect(patron.books()).to(eq(nil))
    end
  end

end
