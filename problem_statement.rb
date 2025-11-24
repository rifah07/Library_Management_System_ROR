# Ruby OOP Challenge: Library Management System
#
# Objective:
#   Build a comprehensive Library Management System using Ruby and Object-Oriented
#   Programming concepts to practice fundamental OOP principles.
#
# Project Description:
#   Implement a system that can:
#     - Store a collection of books and members
#     - Allow members to check out and return books
#     - Track which books are available and which are checked out (and by whom)
#     - Handle basic errors (e.g., book unavailable, member does not exist)
#     - Search for books by various criteria
#     - Track overdue books and manage due dates
#
# Core Requirements:
#   1. Create at least three classes: Book, Member, and Library.
#
#   2. Book class should have:
#      - Attributes: title, author, isbn, availability status
#      - Methods: to_s for string representation, available? predicate method
#      - Consider adding: genre, publication_year, checked_out_by, due_date
#
#   3. Member class should have:
#      - Attributes: name, member_id, list of checked out books
#      - Methods: can_checkout? (check if member can borrow more books)
#      - Consider adding: checkout_limit (e.g., max 3 books), checkout_history
#
#   4. Library class should have methods to:
#      - Add and remove books from the collection
#      - Add and remove members
#      - Check out a book to a member (with due date tracking)
#      - Return a book from a member
#      - Display all books and their status (available/checked out and by whom)
#      - Search for books by title or author
#      - List overdue books
#
#   5. Implement error handling:
#      - Create custom exception classes (BookNotFoundError, MemberNotFoundError,
#        BookUnavailableError, CheckoutLimitError)
#      - Use begin/rescue blocks where appropriate
#      - Validate inputs in constructors and methods
#
# Ruby Best Practices to Implement:
#   - Use attr_reader, attr_accessor, attr_writer appropriately
#   - Implement both public and private methods where needed
#   - Use Ruby enumerable methods: find, select, map, any?, all?, etc.
#   - Follow naming conventions: snake_case for methods/variables, CamelCase for classes
#   - Use symbols for status values (:available, :checked_out)
#   - Implement to_s methods for better object representation
#   - Use predicate methods (methods ending in ?) for boolean checks
#   - Practice nil? checks and Ruby's truthiness
#
# OOP Concepts to Practice:
#   - Encapsulation: Keep internal state private, expose through methods
#   - Composition: Library *has-a* collection of Books and Members
#   - Association: Member *has-many* checked out Books
#   - Single Responsibility: Each class should have one clear purpose
#   - DRY (Don't Repeat Yourself): Reuse code through methods
#
# Intermediate Challenges:
#   - Implement flexible searching (by title, author, ISBN, or genre)
#   - Track checkout and return dates
#   - Calculate and display overdue books (books past their due date)
#   - Implement a checkout limit per member (e.g., max 3 books)
#   - Generate reports: most popular books, member activity, etc.
#   - Add a checkout history for each member
#
# Advanced Challenges (Optional):
#   - Save and load library state from a JSON or YAML file
#   - Implement a Transaction or CheckOut class to represent the borrowing relationship
#   - Add late fee calculation for overdue books
#   - Implement book reservations (member can reserve a checked-out book)
#   - Add different member types (Student, Faculty) with different privileges
#   - Create a CLI (Command Line Interface) for user interaction
#
# Example Usage Structure (DO NOT copy directly, design your own implementation):
#
#   # Initialize library
#   library = Library.new("City Public Library")
#
#   # Create and add books
#   book1 = Book.new("1984", "George Orwell", "978-0451524935")
#   book2 = Book.new("To Kill a Mockingbird", "Harper Lee", "978-0061120084")
#   library.add_book(book1)
#   library.add_book(book2)
#
#   # Create and add members
#   member1 = Member.new("Alice Johnson", 101)
#   member2 = Member.new("Bob Smith", 102)
#   library.add_member(member1)
#   library.add_member(member2)
#
#   # Check out a book
#   library.check_out("1984", 101)  # or library.check_out(book1, member1)
#
#   # Display all books and their status
#   library.display_books
#
#   # Search for books
#   results = library.search_books_by_author("Orwell")
#
#   # Return a book
#   library.return_book("1984", 101)
#
#   # Check overdue books
#   overdue = library.overdue_books
#
# Suggested File Structure:
#   - book.rb          # Book class definition
#   - member.rb        # Member class definition
#   - library.rb       # Library class definition
#   - exceptions.rb    # Custom exception classes (optional)
#   - main.rb          # Test/demo your system here
#
# Testing Checklist:
#   [ ] Can add and remove books from library
#   [ ] Can add and remove members from library
#   [ ] Can check out an available book
#   [ ] Cannot check out an unavailable book
#   [ ] Cannot check out with invalid member_id
#   [ ] Can return a checked out book
#   [ ] Book status updates correctly after checkout/return
#   [ ] Member's checked out books list updates correctly
#   [ ] Search functionality works for different criteria
#   [ ] Overdue books are identified correctly
#   [ ] Display methods show correct information
#   [ ] Error handling works for edge cases
#
# Tips for Success:
#   1. Start simple: Get basic Book, Member, and Library classes working first
#   2. Add one feature at a time and test it thoroughly
#   3. Use descriptive variable and method names
#   4. Keep methods short and focused (aim for < 10 lines when possible)
#   5. Use private methods for internal logic that shouldn't be called externally
#   6. Comment complex logic, but let your code be self-documenting
#   7. Refactor as you go - don't be afraid to restructure your code
#   8. Practice using IRB or Pry to test your classes interactively
#
# Good luck with your Ruby OOP practice! 🚀
# Focus on clean, readable code and solid OOP design principles.

################################################################################