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
        :genre => 'Sci-Fi',
        :checked_out => true,
        :due_date => '2020-01-30'
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
        :genre => 'Sci-Fi',
        :checked_out => true,
        :due_date => '2020-01-30'
      })
      book.save()
      expect(Book.all).to(eq([book]))
    end
  end

end
