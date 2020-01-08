class Book

  attr_reader :id, :name, :genre

  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
    @genre = attributes.fetch(:genre)
  end

  def ==(book_to_compare)
    @id == book_to_compare.id && @name == book_to_compare.name
  end

  def clean(string)
    (string.include?("'")) ? string.gsub("'", "''") : string
  end

  def save
    result = DB.exec("
      INSERT INTO books (name, genre)
      VALUES ('#{self.clean(@name)}', '#{@genre}') RETURNING id;
    ")
    @id = result.first().fetch('id').to_i
  end

  def self.get_books(db_query)
    books_array = []
    db_query_results = DB.exec(db_query)
    db_query_results.each do |book|
      id = book.fetch('id').to_i
      name = book.fetch('name')
      genre = book.fetch('genre')
      books_array.push(Book.new({ :id => id, :name => name, :genre => genre }))
    end
    books_array
  end

  def self.all
    Book.get_books("SELECT * FROM books;")
  end

  def delete
    DB.exec("DELETE FROM books WHERE id = #{@id};")
    DB.exec("DELETE FROM authors_books WHERE book_id = #{@id};")
  end

  def self.find(id)
    Book.get_books("SELECT * FROM books WHERE id = #{id};").first()
  end

  def update(attributes)
    @name = attributes.fetch(:name) || @name
    @genre = attributes.fetch(:genre) || @genre
    DB.exec("
      UPDATE books SET name = '#{self.clean(@name)}', genre = '#{@genre}'
      WHERE id = #{@id};
    ")
  end

  def add_author(name)
    result = Author.get_authors("
      SELECT * FROM authors WHERE name = '#{self.clean(name)}'
    ")
    if(result.length <1)
      author = Author.new({
        :id => nil,
        :name => "#{name}"
      })
      author.save()
      result = [author]
    end
    DB.exec("
      INSERT INTO authors_books (author_id, book_id)
      VALUES (#{result.first().id}, #{@id})
    ")
  end

  def authors
    results = DB.exec("SELECT * FROM authors_books WHERE book_id = #{@id}")
    id_string = results.map{ |result| result.fetch("author_id")}.join(', ')
    (id_string != '') ?
      Author.get_authors("SELECT * FROM authors WHERE id IN (#{id_string});") :
      nil
  end

end
