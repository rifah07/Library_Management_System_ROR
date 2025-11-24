# frozen_string_literal: true
require 'date'
require_relative 'member_type'

# Member using COMPOSITION pattern
class MemberComposition
  attr_reader :name, :member_id, :checked_books, :checkout_history, :member_type

  def initialize(name, member_id, member_type)
    @name = name
    @member_id = member_id
    @member_type = member_type  # Inject type
    @checked_books = []
    @checkout_history = []
  end

  def to_s
    "#{@member_type}.name: #{@name} (ID: #{@member_id}) - Books: #{@checked_books.length}/#{@member_type.checkout_limit}"
  end

  def can_checkout?
    @checked_books.length < @member_type.checkout_limit
  end

  def checkout_limit
    @member_type.checkout_limit
  end

  def checkout_days
    @member_type.checkout_days
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

  # NEW FEATURE: Change member type!
  def upgrade_to_faculty!
    @member_type = FacultyType.new
    puts "#{@name} has been upgraded to Faculty status!"
  end

  def downgrade_to_student!
    @member_type = StudentType.new
    puts "#{@name} has been changed to Student status!"
  end

end
