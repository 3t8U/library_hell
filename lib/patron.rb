class Patron
  attr_reader :id, :name


  def initialize(attributes)
    @name = attributes.fetch(:name)
    @id = attributes.fetch(:id)
  end

  def ==(patron_to_compare)
    @id == patron_to_compare.id && @name == patron_to_compare.name
  end

  def clean(string)
    (string.include?("'")) ? string.gsub("'", "''") : string
  end

  def save
    result = DB.exec("
      INSERT INTO patrons (name)
      VALUES ('#{self.clean(@name)}') RETURNING id;
    ")
    @id = result.first().fetch('id').to_i
  end

  def self.get_patrons(db_query)
    patrons_array = []
    db_query_results = DB.exec(db_query)
    db_query_results.each do |patron|
      id = patron.fetch('id').to_i
      name = patron.fetch('name')
      patrons_array.push(Patron.new({ :id => id, :name => name}))
    end
    patrons_array
  end

  def self.all
    Patron.get_patrons("SELECT * FROM patrons;")
  end

  def delete
    DB.exec("DELETE FROM patrons WHERE id = #{@id};")
    DB.exec("DELETE FROM books_patrons WHERE patron_id = #{@id};")
  end

  def self.find(id)
    Patron.get_patrons("SELECT * FROM patrons WHERE id = #{id};").first()
  end

  def update(attributes)
    @name = attributes.fetch(:name) || @name
    DB.exec("UPDATE patrons SET name = '#{self.clean(@name)}' WHERE id = #{@id};")
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
    due_date = Time.now + Book.lend_time
    DB.exec("
      INSERT INTO books_patrons (book_id, patron_id, due_date)
      VALUES (#{result.first().id}, #{@id}, '#{due_date}')
    ")
  end

  def return_book(book_id)
    results = DB.exec("SELECT * FROM books_patrons WHERE patron_id = #{@id} AND book_id = #{book_id}").first()
    DB.exec("DELETE FROM books_patrons WHERE id = #{results.fetch('id')}")
  end

  def books
    results = DB.exec("SELECT * FROM books_patrons WHERE patron_id = #{@id}")
    id_string = results.map{ |result| result.fetch("book_id")}.join(', ')
    (id_string != '') ?
      Book.get_books("SELECT * FROM books WHERE id IN (#{id_string});") :
      nil
  end

end
