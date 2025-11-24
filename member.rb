# frozen_string_literal: true

# Member class should have:
  # - Attributes: name, member_id, list of checked out books
  # - Methods: can_checkout? (check if member can borrow more books)
  # - Consider adding: checkout_limit (e.g., max 3 books), checkout_history

require 'date'

# This is member class for each member
class Member
  attr_reader :name, :member_id, :checked_books, :checkout_history

  CHECKOUT_LIMIT = 3
  CHECKOUT_DAYS = 14

  def initialize(name, member_id)
    @name = name
    @member_id = member_id
    @checked_books = []
    @checkout_history = []
  end

  def to_s
    member_type = self.class.name
    "#{member_type}: #{@name} (ID: #{@member_id}) - Books: #{@checked_books.length}/#{CHECKOUT_LIMIT}"
  end

  def has_book?(book)
    @checked_books.include?(book)
  end

  def checkout_book(book)
    @checked_books << book

    # Add to history with checkout date
    @checkout_history << {
      book: book,
      checkout_date: Date.today,
      return_date: nil # not returned yet
    }
  end

  def return_book(book)
    @checked_books.delete(book)

    # Find the checkout record in history and update return_date
    history_record = @checkout_history.find {|h| h[:book] == book && h[:return_date].nil?}
    history_record[:return_date] = Date.today if history_record
  end

  def can_checkout?
    @checked_books.length < self.class::CHECKOUT_LIMIT
    # self.class gets the actual class (Student, Faculty, etc.)
    # :: accesses the constant from that class
  end

  # Show all checkout history
  def show_checkout_history
    if @checkout_history.empty?
      puts 'No check out history'
      return
    end

    puts "\n=== Checkout History for #{@name} ==="
    @checkout_history.each_with_index do |record, index|
      status = record[:return_date] ? "Returned: #{record[:return_date]}" : 'Currently checked out'
      puts "#{index + 1}. #{record[:book].title} - Checked out: #{record[:checkout_date]} - #{status}"
    end
  end

  # Count total books ever checked out
  def total_books_checked_out
    @checkout_history.length
  end

end
