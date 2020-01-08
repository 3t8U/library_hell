class Book

  attr_reader :id, :name


  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
    @genre = attributes.fetch(:genre)
    @checked_out = attributes.fetch(:checked_out)
    @due_date = attributes.fetch(:due_date)
  end

  def ==(book_to_compare)
    @id == book_to_compare.id && @name == book_to_compare.name
  end

  def clean(string)
    (string.include?("'")) ? string.gsub("'", "''") : string
  end

  def save
    result = DB.exec("
      INSERT INTO books (name, genre, checked_out, due_date)
      VALUES (
        '#{self.clean(@name)}',
        '#{@genre}',
        #{@checked_out},
        '#{@due_date}'
      ) RETURNING id;")
    @id = result.first().fetch('id').to_i
  end

  def self.get_books(db_query)
    books_array = []
    db_query_results = DB.exec(db_query)
    db_query_results.each do |book|
      id = book.fetch('id').to_i
      name = book.fetch('name')
      genre = book.fetch('genre')
      checked_out = (book.fetch('checked_out') == 't')
      due_date = book.fetch('due_date')
      books_array.push(Book.new({
        :id => id,
        :name => name,
        :genre => genre,
        :checked_out => checked_out,
        :due_date => due_date
      }))
    end
    books_array
  end

  def self.all
    Book.get_books("SELECT * FROM books;")
  end

end
