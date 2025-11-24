# frozen_string_literal: true

# Library class should have methods to:
#      - Add and remove books from the collection
#      - Add and remove members
#      - Check out a book to a member (with due date tracking)
#      - Return a book from a member
#      - Display all books and their status (available/checked out and by whom)
#      - Search for books by title or author
#      - List overdue books

require 'date'
require 'json'
require_relative 'exceptions'
require_relative 'Member'
require_relative 'student'
require_relative 'faculty'
require_relative 'regular_member'
require_relative 'member_type'
require_relative 'member_composition'

# This is Library class
class Library
  attr_reader :name

  CHECKOUT_DAYS = 15

  def initialize(name)
    @name = name
    @books = [] # using array, hash when Large datasets (1000+)
    @members = []
  end

  def add_book(book)
    @books << book
  end

  def remove_book(isbn)
    # book = @books.find {|b| b.isbn == isbn}
    # @books.delete(book) if book

    @books.delete_if { |book| book.isbn == isbn }
  end

  def add_member(member)
    @members << member
  end

  def remove_member(id)
    # member = @members.find {|m| m.id == id}
    # @members.delete(member) if member
    @members.delete_if {|member| member.member_id == id}
  end

=begin
  def check_out(isbn, member_id)
    book = @books.find { |b| b.isbn == isbn}
    # return 'Book not found' if book.nil?
    raise BookNotFoundError, "Book with ISBN '#{isbn}' not found" unless book

    member = @members.find { |m| m.member_id == member_id}
    # return 'Member not found' if member.nil?
    raise MemberNotFoundError, "Member with ID #{member_id} not found" unless member

    # return 'Book not available' unless book.available?
    # return 'Member at checkout limit' unless member.can_checkout?
    raise BookUnavailableError, "'#{book.title}' is currently checked out" unless book.available?
    raise CheckoutLimitError.new(member.name, member.class::CHECKOUT_LIMIT) unless member.can_checkout?

    book.availability_status = :checked_out
    book.checked_out_by = member
    book.due_date = Date.today + member.class::CHECKOUT_DAYS

    member.checkout_book(book)
    "#{book.title} checked out to #{member.name}. Due: #{book.due_date}"
  end
=end

  def check_out(isbn, member_id)
    book = @books.find { |b| b.isbn == isbn}
    # return 'Book not found' if book.nil?
    raise BookNotFoundError, "Book with ISBN '#{isbn}' not found" unless book

    member = @members.find { |m| m.member_id == member_id}
    # return 'Member not found' if member.nil?
    raise MemberNotFoundError, "Member with ID #{member_id} not found" unless member

    # return 'Book not available' unless book.available?
    # return 'Member at checkout limit' unless member.can_checkout?
    raise BookUnavailableError, "'#{book.title}' is currently checked out" unless book.available?

    # Get checkout limit - works for BOTH inheritance and composition!
    limit = get_member_checkout_limit(member)
    raise CheckoutLimitError.new(member.name, limit) unless member.can_checkout?

    book.availability_status = :checked_out
    book.checked_out_by = member

    # Get checkout days - works for BOTH patterns!
    book.due_date = Date.today + get_member_checkout_days(member)

    member.checkout_book(book)
    "#{book.title} checked out to #{member.name}. Due: #{book.due_date}"
  end



  def return_book(isbn, member_id)
    book = @books.find { |b| b.isbn == isbn}
    # return 'Book not found' if book.nil?
    raise BookNotFoundError, "Book with ISBN '#{isbn}' not found" unless book

    member = @members.find { |m| m.member_id == member_id}
    # return 'Member not found' if member.nil?
    raise MemberNotFoundError, "Member with ID #{member_id} not found" unless member

    # return 'Book is not checked out.' unless book.checked_out?
    # return 'Member does not have this book' unless member.has_book?(book)
    raise BookNotCheckedOutError, 'This book is not checked out!' unless book.checked_out?
    raise WrongMemberError, "Member with this id: '#{member_id}' does not have this book" unless member.has_book?(book)

    book.availability_status = :available
    book.checked_out_by = nil
    book.due_date = nil
    member.return_book(book)
    "#{book.title} returned by #{member.name}. Thank you!"
  end

  def display_books
    if @books.empty?
      puts 'No books in the library!'
      return
    end

    puts "\n=== Books in #{@name} ==="
    @books.each_with_index do |book, index|
      puts "#{index + 1}. #{book}"

      if book.available?
        puts '   Status: Available'
      else
        puts "   Status: Checked out by #{book.checked_out_by.name} (Due: #{book.due_date})"
      end
    end
  end

  def overdue_books
    result = @books.select { |b| b.checked_out? && b.due_date < Date.today }

    return 'No books found passing due date' if result.empty?

    result
  end

  def search_books_by_title(title)
    results = @books.select {|b| b.title.downcase.include?(title.downcase)} # find returns single element, select returns array

    return "No books found with title matching '#{title}'" if results.empty?

    results
  end

  def search_books_by_author(author)
    results = @books.select {|b| b.author.downcase.include?(author.downcase)}

    return "No books found with author name matching '#{author}'" if results.empty?

    results
  end

  def search_books_by_genre(genre)
    results = @books.select {|b| b.genre.downcase.include?(genre.downcase)}

    return "No books found with genre matching '#{genre}'" if results.empty?

    results
  end

  def find_member(member_id)
    member = @members.find { |m| m.member_id == member_id }
    raise MemberNotFoundError, "Member with ID '#{member_id}' not found" unless member

    member
  end

  # Works with both inheritance (Student, Faculty) and composition (MemberComposition)
  def get_member_checkout_limit(member)
    if member.respond_to?(:checkout_limit) # Ruby method respond_to? checks if an object has a specific method.
      # Composition: has checkout_limit method
      member.checkout_limit
    else
      # Inheritance: use class constant
      member.class::CHECKOUT_LIMIT
    end
  end

  def get_member_checkout_days(member)
    if member.respond_to?(:checkout_days)
      member.checkout_limit # Composition
    else
      member.class::CHECKOUT_DAYS  # Inheritance
    end
  end

  def save_to_file(filename = 'library_data.json')
    data = {
      library_name: @name,
      books: serialize_books,
      members: serialize_members
    }

    # Create 'data' folder if it doesn't exist
    Dir.mkdir('data') unless Dir.exist?('data')

    # Save inside the data folder
    filepath = File.join('data', filename)

    File.write(filepath, JSON.pretty_generate(data))

    puts "✓ Library saved to #{filename}"
  rescue => e
    puts "✗ Error saving library: #{e.message}"
  end

  def self.load_from_file(filename = 'library_data.json')
    filepath = File.join('data', filename)

    unless File.exist?(filepath)
      puts "✗ File '#{filepath}' not found!"
      return nil
    end

    data = JSON.parse(File.read(filepath), symbolize_names: true)

    # Create new library
    library = Library.new(data[:library_name])

    # Recreate books
    library.load_books(data[:books])

    # Recreate members
    library.load_members(data[:members])

    # Reconnect relationships (books ↔ members)
    library.reconnect_relationships(data)

    puts "✓ Library loaded from #{filepath}"
    library
  rescue => e
    puts "✗ Error loading library: #{e.message}"
    puts e.backtrace.first(5)
    nil

  end

  # Load books from JSON data
  def load_books(book_data)
    book_data.each do |book_data|
      book = Book.new(
        book_data[:title],
        book_data[:author],
        book_data[:isbn],
        book_data[:genre],
        book_data[:publication_year]
      )

      # Restore status (will reconnect member later)
      book.availability_status = book_data[:availability_status].to_sym

      # Restore due date if exists
      book.due_date = Date.parse(book_data[:due_date]) if book_data[:due_date]

      @books << book
    end
  end

  # Load members from JSON data
  def load_members(members_data)
    members_data.each do |member_data|
      member = create_member_from_data(member_data)
      @members << member if member
    end
  end


  # Reconnect books to members
  def reconnect_relationships(data)
    data[:books].each do |book_data|
      next unless book_data[:checked_out_by_id]

      # Find the book and member
      book = @books.find {|b| b.isbn == book_data[:isbn] }
      member = @members.find {|m| m.member_id == book_data[:checked_out_by_id] }

      if book && member
        # Reconnect the relationship
        book.checked_out_by = member
        member.checked_books << book unless member.checked_books.include?(book)
      end
    end

    # Restore checkout history
    data[:members].each do |member_data|
      member = @members.find { |m| m.member_id == member_data[:member_id] }
      next unless member

      restore_checkout_history(member, member_data[:checkout_history])
    end
  end

  # Restore member's checkout history
  def restore_checkout_history(member, history_data)
    history_data.each do |record|
      book = @books.find { |b| b.isbn == record[:book_isbn] }
      next unless book

      checkout_date = record[:checkout_date] ? Date.parse(record[:checkout_date]) : Date.today

      # Only parse return_date if it exists and is not nil
      return_date = if record[:return_date] && !record[:return_date].empty?
                      Date.parse(record[:return_date])
                    else
                      nil
                    end

      member.checkout_history << {
        book: book,
        checkout_date: checkout_date,
        return_date: return_date
      }
    end
  end


  # private methods from here
  private

  # Convert books to JSON-friendly format
  def serialize_books
    @books.map do |book|
      {
        title: book.title,
        author: book.author,
        isbn: book.isbn,
        genre: book.genre,
        publication_year: book.publication_year,
        availability_status: book.availability_status.to_s,
        checked_out_by_id: book.checked_out_by&.member_id, # book.checked_out_by ? book.checked_out_by.member_id : nil
        due_date: book.due_date&.to_s # book.due_date ? book.due_date.to_s : nil
      }
    end
  end

  def serialize_members
    @members.map do |member|
      {
        name: member.name,
        member_id: member.member_id,
        member_class: member.class.name, # "Student", "Faculty", "MemberComposition", etc.
        member_type: get_member_type_name(member), # For composition members
        checked_book_isbns: member.checked_books.map(&:isbn),
        checkout_history: serialize_checkout_history(member)
      }
    end
  end


  def get_member_type_name(member)
    if member.respond_to?(:member_type)
      member.member_type # Composition
    else
      member.class.name # inheritance
    end
  end

  def serialize_checkout_history(member)
    member.checkout_history.map do |record|
      {
        book_isbn: record[:book].isbn,
        checkout_days: record[:checkout_days].to_s,
        return_date: record[:return_date]&.to_s
      }
    end
  end


  # Create the correct member type
  def create_member_from_data(member_data)
    case member_data[:member_class]
    when 'Student'
      Student.new(member_data[:name], member_data[:member_id])
    when 'Faculty'
      Faculty.new(member_data[:name], member_data[:member_id])
    when 'RegularMember'
      RegularMember.new(member_data[:name], member_data[:member_id])
    when 'MemberComposition'
      member_type = create_member_type(member_data[:member_type])
      MemberComposition.new(member_data[:member_type], member_data[:member_id], member_type)
    else
      # Default
      Member.new(member_data[:name], member_data[:member_id])
    end

  end

  # Create member type for composition members
  def create_member_type(type_name)
    case type_name
    when 'Student'
      StudentType.new
    when 'Faculty'
      FacultyType.new
    when 'RegularMember'
      RegularMemberType.new
    # when 'Senior Citizen'
      # SeniorType.new
    else
      RegularMemberType.new
    end
  end


end
