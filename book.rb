# frozen_string_literal: true

# Book class should have:
# - Attributes: title, author, isbn, availability status
# - Methods: to_s for string representation, available? predicate method
# - Consider adding: genre, publication_year, checked_out_by, due_date

# Book represents a book in the library.
class Book
  attr_accessor :availability_status, :checked_out_by, :due_date
  attr_reader :title, :author, :isbn, :genre, :publication_year

  def initialize(title, author, isbn, genre, publication_year)
    @title = title
    @author = author
    @isbn = isbn
    @genre = genre
    @publication_year = publication_year
    @availability_status = :available
  end
  # Ruby initializes unset instance variables to nil automatically.

  def to_s
    "#{title} by #{author} (#{publication_year}) - ISBN: #{isbn}"
  end

  def available?
    @availability_status == :available
  end

  def checked_out?
    !available?
    # !@checked_out_by.nil?
  end
end
