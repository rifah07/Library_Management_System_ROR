# frozen_string_literal: true

# ============================================================================
# Library Management System - Demo & Testing Suite
# ============================================================================
#
# This file demonstrates all features of the Library Management System:
# - CRUD operations for books and members
# - Checkout/return workflows with validation
# - Search functionality (title, author, genre)
# - Exception handling
# - Different member types (inheritance vs composition)
# - Data persistence (save/load)
# - Checkout history tracking
#
# Author: Rifah Sajida Deya
# Date: November 2025
# ============================================================================

require 'date'
require 'json'
require_relative 'Book'
require_relative 'Member'
require_relative 'Library'
require_relative 'student'
require_relative 'faculty'
require_relative 'regular_member'
require_relative 'member_type'
require_relative 'member_composition'

puts '=' * 60
puts 'LIBRARY MANAGEMENT SYSTEM - TESTING'
puts '=' * 60

# Create library
library = Library.new('City Public Library')

# Create and add books
book1 = Book.new('1984', 'George Orwell', '978-0451524935', 'Dystopian', 1949)
book2 = Book.new('To Kill a Mockingbird', 'Harper Lee', '978-0061120084', 'Fiction', 1960)
book3 = Book.new('The Great Gatsby', 'F. Scott Fitzgerald', '978-0743273565', 'Classic', 1925)
book4 = Book.new('Brave New World', 'Aldous Huxley', '978-0060850524', 'Dystopian', 1932)
book5 = Book.new("Harry Potter", "J.K. Rowling", "978-0439708180", "Fantasy", 1997)
book6 = Book.new("The Hobbit", "J.R.R. Tolkien", "978-0547928227", "Fantasy", 1937)
book7 = Book.new("Dune", "Frank Herbert", "978-0441172719", "Sci-Fi", 1965)
book8 = Book.new("Physics 101", "Dr. Jones", "978-1234567890", "Science", 2020)
book9 = Book.new("Chemistry", "Dr. Lee", "978-1234567891", "Science", 2021)
book10 = Book.new("Biology", "Dr. Wang", "978-1234567892", "Science", 2019)

library.add_book(book1)
library.add_book(book2)
library.add_book(book3)
library.add_book(book4)
library.add_book(book5)
library.add_book(book6)
library.add_book(book7)
library.add_book(book8)
library.add_book(book9)
library.add_book(book10)

# Create and add members
member1 = Member.new('Alice Johnson', 101)
member2 = Member.new('Bob Smith', 102)

# Create different member types
student = Student.new("Charlie Brown", 201)
faculty = Faculty.new("Dr. Smith", 202)
regular = RegularMember.new("Jane Doe", 203)

library.add_member(member1)
library.add_member(member2)

library.add_member(student)
library.add_member(faculty)
library.add_member(regular)

# Display all books
puts "\n=== Test 1: Display All Books ==="
library.display_books

# Search tests
puts "\n=== Test 2: Search for 'kill' ==="
results = library.search_books_by_title('kill')
if results.is_a?(Array)
  results.each { |book| puts "  - #{book}"}
else
  puts results # Error message
end

puts "\n=== Test 3: Search for 'Orwell' ==="
results = library.search_books_by_author('Orwell')
if results.is_a?(Array)
  results.each { |book| puts "  - #{book}"}
else
  puts results # Error message
end


# Checkout test with exception handling
puts "\n=== Test 4: Successful Checkout ==="
begin
  result = library.check_out('978-0451524935', 101)
  puts "✓ SUCCESS: #{result}"
rescue LibraryError => e
  puts "✗ ERROR: #{e.message}"
end

puts "\n=== After Checkout ==="
library.display_books

# Try to check out when not available
puts "\n=== Test 5: Try to Checkout Already Checked Out Book ==="
begin
  result = library.check_out('978-0451524935', 102)
  puts "✓ SUCCESS: #{result}"
rescue BookUnavailableError => e
  puts "✗ ERROR (Expected): #{e.message}"
rescue LibraryError => e
  puts "✗ ERROR (Expected): #{e.message}"
end

# Try to check out with invalid ISBN
puts "\n=== Test 6: Try to Checkout with Invalid ISBN ==="
begin
  result = library.check_out('invalid-isbn', 101)
  puts "✓ SUCCESS: #{result}"
rescue BookNotFoundError => e
  puts "✗ ERROR (Expected): #{e.message}"
rescue LibraryError => e
  puts "✗ ERROR: #{e.message}"
end

# Try to check out with invalid member
puts "\n=== Test 7: Try to Checkout with Invalid Member ID ==="
begin
  result = library.check_out('978-0451524935', 999)
  puts "✓ SUCCESS: #{result}"
rescue MemberNotFoundError => e
  puts "✗ ERROR (Expected): #{e.message}"
rescue LibraryError => e
  puts "✗ ERROR: #{e.message}"
end

# Test check out limit
puts "\n=== Test 8: Test Checkout Limit (3 books max) ==="
begin
  # Alice already has 1 book, checkout 2 more
  result1 = library.check_out('978-0061120084', 101)
  puts "✓ Book 2 checked out: #{result1}"

  result2 = library.check_out('978-0743273565', 101)
  puts "✓ Book 3 checked out: #{result2}"

  # Try to check out 4th book - should fail
  result3 = library.check_out('978-0060850524', 101)
  puts "✓ Book 4 checked out: #{result3}"
rescue CheckoutLimitError => e
  puts "✗ ERROR (Expected): #{e.message}"
  puts "   Member: #{e.member_name}"
  puts "   Limit: #{e.limit}"
rescue LibraryError => e
  puts "✗ ERROR: #{e.message}"
end

puts "\n=== Current Library Status ==="
library.display_books

# Return test
puts "\n=== Test 9: Successful Return ==="
begin
  result = library.return_book('978-0451524935', 101)
  puts "✓ SUCCESS: #{result}"
rescue LibraryError => e
  puts "✗ ERROR: #{e.message}"
end

puts "\n=== After Return ==="
library.display_books

# Try to Return Book Member Doesn't Have
puts "\n=== Test 10: Try to Return Book Member Doesn't Have ==="
begin
  result = library.return_book('978-0061120084', 102)
  puts "✓ SUCCESS: #{result}"
rescue WrongMemberError => e
  puts "✗ ERROR (Expected): #{e.message}"
rescue LibraryError => e
  puts "✗ ERROR: #{e.message}"
end

# Try to return book that's not checked out
puts "\n=== Test 11: Try to Return Available Book ==="
begin
  result = library.return_book('978-0060850524', 101)
  puts "✓ SUCCESS: #{result}"
rescue BookNotCheckedOutError => e
  puts "✗ ERROR (Expected): #{e.message}"
rescue LibraryError => e
  puts "✗ ERROR: #{e.message}"
end

# Overdue test (simulate overdue)
puts "\n=== Test 12: Overdue Books ==="
# Make book2 overdue (it's checked out by Alice)
book2.due_date = Date.today - 1 # Make it overdue
puts "Setting '#{book2.title}' as 5 days overdue..."

overdue = library.overdue_books
if overdue.is_a?(Array)
  puts "Found #{overdue.length} overdue book(s):"
  overdue.each do |book|
    puts "  - #{book.title} (Due: #{book.due_date}, Checked out by: #{book.checked_out_by.name})"
  end
else
  puts overdue
end

# Test search with no results
puts "\n=== Test 13: Search with No Results ==="
result = library.search_books_by_title('Alchemy')
puts result

# Test search by genre
puts "\n=== Test 14: Search by Genre ==="
results = library.search_books_by_genre('Dystopian')
if results.is_a?(Array)
  puts "Found #{results.length} Dystopian book(s):"
  results.each {|b| puts "  - #{b}"}
else
  puts results
end


puts "\n=== Test 15: Testing Checkout History ==="

puts "\n=== Alice's Checkout Activity ==="

begin
  # Alice already has books checked out, let's do more activity
  puts library.return_book('978-0061120084', 101)
  puts library.return_book('978-0743273565', 101)
  puts library.check_out('978-0060850524', 101)
  puts library.check_out('978-0451524935', 101)  # Re-checkout 1984
rescue LibraryError => e
  puts "Error: #{e.message}"
end

puts "\n=== Alice's Complete Checkout History ==="
begin
  alice = library.find_member(101)
  alice.show_checkout_history
  puts "\n Alice's Stats:"
  puts "  Total checkouts all-time: #{alice.total_books_checked_out}"
  puts "  Currently has: #{alice.checked_books.length} book(s)"
rescue LibraryError => e
  puts "Error: #{e.message}"
end

puts "\n=== Bob's Checkout Activity ==="
begin
  puts library.check_out('978-0061120084', 102)  # Now available
  puts library.check_out('978-0743273565', 102)

  bob = library.find_member(102)
  bob.show_checkout_history
  puts "\n Bob's Stats:"
  puts "  Total checkouts all-time: #{bob.total_books_checked_out}"
  puts "  Currently has: #{bob.checked_books.length} book(s)"
rescue LibraryError => e
  puts "Error: #{e.message}"
end

# Test Student limit (2 books)
puts "\n=== Test 16: Test Checkout Limits by Member Type ==="
puts "\n--- Student (Charlie) - Limit: 2 books ---"
begin
  puts "✓ Book 1: #{library.check_out('978-0439708180', 201)}"
  puts "✓ Book 2: #{library.check_out('978-0547928227', 201)}"
  puts "✓ Book 3 (should fail): #{library.check_out('978-0441172719', 201)}"
rescue CheckoutLimitError => e
  puts "✗ ERROR (Expected): #{e.message}"
  puts "   Limit: #{e.limit}"
rescue LibraryError => e
  puts "Error: #{e.message}"
end

# Test Faculty limit (5 books)
puts "\n--- Faculty (Dr. Smith) - Limit: 5 books ---"
begin
  puts "✓ Book 1: #{library.check_out('978-0441172719', 202)}"
  puts "✓ Book 2: #{library.check_out('978-1234567890', 202)}"
  puts "✓ Book 3: #{library.check_out('978-1234567891', 202)}"
  puts "✓ Book 4: #{library.check_out('978-1234567892', 202)}"

  library.return_book('978-0060850524', 101) # Free up a book from Alice
  library.return_book('978-0451524935', 101)
  puts "✓ Book 5: #{library.check_out('978-0060850524', 202)}"

  # Try 6th book - should fail
  puts "✓ Book 6 (should fail): #{library.check_out('978-0451524935', 202)}"
rescue CheckoutLimitError => e
  puts "✗ ERROR (Expected): #{e.message}"
  puts "   Limit: #{e.limit}"
rescue LibraryError => e
  puts "Error: #{e.message}"
end

# Test Regular Member limit (3 books)
puts "\n--- Regular Member (Jane) - Limit: 3 books ---"
begin
  puts "✓ Book 1: #{library.check_out('978-0451524935', 203)}"

  # Need to free up books
  student_member = library.find_member(201)
  puts "\nCharlie returns books..."
  library.return_book('978-0439708180', 201)
  # noinspection RubyScope
  library.return_book('978-0547928227', 201)
  library.return_book('978-0441172719', 202)

  puts "\n✓ Book 2: #{library.check_out('978-0439708180', 203)}"
  puts "✓ Book 3: #{library.check_out('978-0547928227', 203)}"

  # Try 4th - should fail
  puts "✓ Book 4 (should fail): #{library.check_out('978-0441172719', 203)}"
rescue CheckoutLimitError => e
  puts "✗ ERROR (Expected): #{e.message}"
  puts "   Limit: #{e.limit}"
rescue LibraryError => e
  puts "✗ ERROR: #{e.message}"
end


puts "\n=== Test 17: Test Different Checkout Durations ==="

charlie_books = library.find_member(201)
dr_smith_books = library.find_member(202)
jane_books = library.find_member(203)

puts "\nCharlie (Student) checkout history:"
charlie_books.show_checkout_history

puts "\nDr. Smith (Faculty) checkout history:"
dr_smith_books.show_checkout_history

puts "\nJane (Regular) checkout history:"
jane_books.show_checkout_history

puts "\n=== Comparing Due Dates ==="
# Check the due dates to see different durations
puts 'Note: Students get 14 days, Faculty get 30 days, Regular get 14 days'


puts "\n=== Library Status ==="
library.display_books


puts "\n" + "=" * 40
puts 'TESTING COMPOSITION PATTERN'
puts "=" * 40

puts "\n===Creating Members with Composition ==="

# Create composition-based members
comp_student = MemberComposition.new('Emma Watson', 301, StudentType.new)
comp_faculty = MemberComposition.new('Prof. Mc Gonagall', 302, FacultyType.new)
comp_regular = MemberComposition.new('Harry Miller', 303, RegularMemberType.new)

library.add_member(comp_student)
library.add_member(comp_faculty)
library.add_member(comp_regular)

puts "\n=== Test: Student Checkout Limit (Composition) ==="
begin
  # Make the books available to use
  library.return_book('978-0451524935', 203)
  library.return_book('978-0061120084', 102)
  library.return_book('978-0743273565', 102)
  library.return_book('978-0060850524', 202)
  library.return_book('978-0439708180', 203)
  library.return_book('978-0547928227', 203)
  library.return_book('978-1234567890', 202)
  library.return_book('978-1234567891', 202)
  library.return_book('978-1234567892', 202)

  puts library.check_out('978-0451524935', 301)
  puts library.check_out('978-0061120084', 301)
  puts library.check_out('978-0743273565', 301) # Error as limit is 2
rescue CheckoutLimitError => e
  puts "✗ ERROR (Expected): #{e.message}"
  puts "   Limit: #{e.limit}"
rescue LibraryError => e
  puts "   Error: #{e.message}"
end

puts "\n=== 🎓 MAGIC: Emma Graduates! Student → Faculty ==="
emma = library.find_member(301)
puts "Before: #{emma}"
puts "Checkout limit before: #{emma.checkout_limit}"

# THE MAGIC MOMENT!
emma.upgrade_to_faculty!

puts "After: #{emma}"
puts "Checkout limit after: #{emma.checkout_limit}"
puts 'Type changed at runtime! History preserved!'

puts "\n=== Now Emma Can Checkout More Books! ==="
begin
  puts library.check_out('978-0743273565', 301)
  puts library.check_out('978-0060850524', 301)
  puts library.check_out('978-0439708180', 301)
rescue LibraryError => e
  puts "Error: #{e.message}"
end

puts "\n=== Emma's Complete History (Preserved Through Upgrade!) ==="
emma.show_checkout_history

puts "\n=== Comparing Inheritance vs Composition ==="
puts "\nInheritance (Charlie - Student class):"
charlie = library.find_member(201)
puts charlie
puts "  - Class: #{charlie.class.name}"
puts '  - Can change type? NO'

puts "\nComposition (Emma - MemberComposition with FacultyType):"
puts emma
puts "  - Class: #{emma.class.name}"
puts "  - Member Type: #{emma.member_type.name}"
puts '  - Can change type? YES'

puts "\n" + "=" * 30
puts 'COMPOSITION TESTING COMPLETE'
puts "=" * 30

puts "\n=== Library Status ==="
library.display_books

puts "\n" + "=" * 40
puts 'TESTING SAVE/LOAD FUNCTIONALITY'
puts "=" * 40

puts "Current directory: #{Dir.pwd}"

puts "\n=== Saving Library State ==="
library.save_to_file('my_library.json')
puts "\n✓ Check your project folder - you should see 'my_library.json' file!"

puts "\n=== Loading Library State ==="
loaded_library = Library.load_from_file('my_library.json')

if loaded_library
  puts "\n✓ Library loaded successfully!"
  puts "Library name: #{loaded_library.name}"

  puts "\n=== Loaded Books ==="
  loaded_library.display_books

  puts "\n=== Loaded Members ==="
  # Show a few members
  alice = loaded_library.find_member(101) rescue nil
  if alice
    puts alice
    alice.show_checkout_history
  end
end

puts "\n=== Loading Library from File ==="
loaded_library = Library.load_from_file('my_library.json')

if loaded_library
  puts "\n✓ Library loaded successfully!"
  puts "Library name: #{loaded_library.name}"

  puts "\n=== Loaded Books ==="
  loaded_library.display_books

  puts "\n=== Loaded Members ==="
  # Show a few members
  alice = loaded_library.find_member(101) rescue nil
  if alice
    puts alice
    alice.show_checkout_history
  end
end

puts "\n" + "=" * 60
puts "FINAL VERIFICATION: SAVE → LOAD → VERIFY"
puts "=" * 60

puts "\n1. Saving current state..."
library.save_to_file('final_test.json')

puts "\n2. Loading from file..."
loaded = Library.load_from_file('final_test.json')

puts "\n3. Verifying loaded data..."
if loaded
  puts "✓ Library name: #{loaded.name}"
  puts "✓ Books count: #{loaded.instance_variable_get(:@books).length}"
  puts "✓ Members count: #{loaded.instance_variable_get(:@members).length}"

  # Test that operations work on loaded library
  puts "\n4. Testing operations on loaded library..."
  begin
    # Try a checkout
    puts loaded.check_out('978-0439708180', 301)
    puts "✓ Checkout works on loaded library!"
  rescue LibraryError => e
    puts "Note: #{e.message}"
  end

  puts "\n✅ PERSISTENCE SYSTEM FULLY FUNCTIONAL!"
else
  puts "✗ Load failed!"
end

puts "\n=== Final Library Status ==="
library.display_books

puts "\n" + "=" * 60
puts 'TESTING COMPLETE'
puts "=" * 60
