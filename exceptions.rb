# frozen_string_literal: true

# Custom exceptions here

require 'date'
class LibraryError < StandardError

end

class BookNotFoundError < LibraryError

end

class MemberNotFoundError < LibraryError

end

class BookAlreadyCheckedOutError < LibraryError

end

class BookNotCheckedOutError < LibraryError

end

class WrongMemberError < LibraryError

end

class BookUnavailableError < LibraryError

end

class DuplicateBookError < LibraryError

end

class DuplicateMemberError < LibraryError

end


# Important business logic - store data
class CheckoutLimitError < LibraryError
  attr_reader :member_name, :limit

  def initialize(member_name, limit)
    @member_name = member_name
    @limit = limit
    super("#{member_name} has reached to the checkout limit of #{limit} books")
  end
end

class OverdueBookError < LibraryError
  attr_reader :book_title, :due_date, :days_overdue

  def initialize(book_title, due_date)
    @book_title = book_title
    @due_date = due_date
    @days_overdue = (Date.today - due_date).to_i
    super("'#{@book_title}' is overdue by #{@days_overdue} days (due: #{due_date})")
  end

end

# Validation errors - default messages
class InvalidISBNError < LibraryError
  def initialize(isbn = nil)
    message = isbn ? "Invalid ISBN format: '#{isbn}'" : 'Invalid ISBN format'
    super(message)
  end
end

class InvalidMemberIDError < LibraryError
  def initialize(member_id = nil)
    message = member_id ? "Invalid member ID: '#{member_id}'" : 'Invalid member ID'
    super(message)
  end
end