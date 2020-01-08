class Author
  attr_reader :id, :name


  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  def ==(author_to_compare)
    @id == author_to_compare.id && @name == author_to_compare.name
  end

  def clean(string)
    (string.include?("'")) ? string.gsub("'", "''") : string
  end

  def save
    result = DB.exec("
      INSERT INTO authors (name)
      VALUES ('#{self.clean(@name)}') RETURNING id;
    ")
    @id = result.first().fetch('id').to_i
  end

  def self.get_authors(db_query)
    authors_array = []
    db_query_results = DB.exec(db_query)
    db_query_results.each do |author|
      id = author.fetch('id').to_i
      name = author.fetch('name')
      authors_array.push(Author.new({ :id => id, :name => name}))
    end
    authors_array
  end

  def self.all
    Author.get_authors("SELECT * FROM authors;")
  end

  def delete
    DB.exec("DELETE FROM authors WHERE id = #{@id};")
    DB.exec("DELETE FROM authors_books WHERE author_id = #{@id};")
  end

  def self.find(id)
    Author.get_authors("SELECT * FROM authors WHERE id = #{id};").first()
  end

  def update(attributes)
    @name = attributes.fetch(:name) || @name
    DB.exec("UPDATE authors SET name = '#{self.clean(@name)}' WHERE id = #{@id};")
  end

  def add_book(name)
    result = Book.get_books("
      SELECT * FROM books WHERE name = '#{self.clean(name)}'
    ")
    if(result.length <1)
      book = Book.new({
        :id => nil,
        :name => "#{name}",
        :genre => "TBD"
      })
      book.save()
      result = [book]
    end
    DB.exec("
      INSERT INTO authors_books (book_id, author_id)
      VALUES (#{result.first().id}, #{@id})
    ")
  end

  def books
    results = DB.exec("SELECT * FROM authors_books WHERE author_id = #{@id}")
    id_string = results.map{ |result| result.fetch("book_id")}.join(', ')
    (id_string != '') ?
      Book.get_books("SELECT * FROM books WHERE id IN (#{id_string});") :
      nil
  end

end
