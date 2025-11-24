# 📚 Library Management System

A comprehensive library management system built with Ruby, demonstrating advanced OOP concepts, design patterns, and data persistence.

![Ruby](https://img.shields.io/badge/Ruby-3.x-red?style=flat&logo=ruby)
![Status](https://img.shields.io/badge/Status-Complete-success)

## 🌟 Features

### Core Functionality
- ✅ **Book Management**: Add, remove, search, and track books
- ✅ **Member Management**: Support for multiple member types with different privileges
- ✅ **Checkout System**: Complete book borrowing and return workflow
- ✅ **Search System**: Search by title, author, or genre (case-insensitive, partial matching)
- ✅ **Overdue Tracking**: Automatic detection of overdue books
- ✅ **Checkout History**: Complete history tracking for all members

### Advanced Features
- ✅ **Data Persistence**: Save and load library state to/from JSON
- ✅ **Custom Exceptions**: 13 custom exception types with proper error handling
- ✅ **Multiple Member Types**: Students, Faculty, Regular Members (different limits & durations)
- ✅ **Design Patterns**: Both Inheritance and Composition patterns implemented

## 🏗️ Architecture

### Design Patterns Used
- **Inheritance Pattern**: Student, Faculty, RegularMember classes
- **Composition Pattern**: MemberComposition with pluggable MemberType
- **Factory Pattern**: Dynamic member creation from JSON data
- **Repository Pattern**: Centralized data management in Library class

### Project Structure
```
library_management/
├── data/                    # Persistent storage
│   └── library_data.json/my_library.json
│
├── Book.rb                  # Book entity
├── Member.rb                # Base member class
├── student.rb               # Student member type
├── faculty.rb               # Faculty member type
├── regular_member.rb        # Regular member type
├── member_composition.rb    # Composition-based member
├── member_type.rb           # Member type definitions
├── library.rb               # Main library controller
├── exceptions.rb            # Custom exception hierarchy
├── main.rb                  # Demo & testing
└── README.md               # This file
```

## 💻 Technical Highlights

### Object-Oriented Programming
- Proper encapsulation with public/private methods
- Inheritance hierarchies with method overriding
- Composition over inheritance where appropriate
- Polymorphic behavior across member types

### Ruby Best Practices
- Predicate methods (`available?`, `can_checkout?`)
- Safe navigation operator (`&.`)
- Proper use of symbols vs strings
- Idiomatic Ruby code throughout

### Error Handling
- Custom exception hierarchy (13 types)
- Comprehensive error messages
- Graceful error recovery
- Exception data storage for debugging

### Data Persistence
- JSON serialization/deserialization
- Object relationship reconstruction
- Date handling and conversion
- File system organization

## 🚀 Getting Started

### Prerequisites
- Ruby 3.x or higher
- No external gems required (uses only Ruby standard library)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/rifah07/Library_Management_System_ROR.git
cd Library_Management_System_ROR
```

2. Run the demo:
```bash
ruby main.rb
```

## 📖 Usage Examples

### Basic Operations
```ruby
# Create a library
library = Library.new("City Public Library")

# Add books
book = Book.new("1984", "George Orwell", "978-0451524935", "Dystopian", 1949)
library.add_book(book)

# Add members
student = Student.new("Alice", 101)  # 2 books, 14 days
library.add_member(student)

# Check out a book
library.check_out("978-0451524935", 101)

# Search books
results = library.search_books_by_author("Orwell")

# Save library state
library.save_to_file("my_library.json")

# Load library state
loaded_library = Library.load_from_file("my_library.json")
```

### Advanced Usage
```ruby
# Using composition pattern for flexible member types
faculty_member = MemberComposition.new("Dr. Smith", 202, FacultyType.new)

# Change member type at runtime (composition only)
faculty_member.upgrade_to_faculty!

# View checkout history
member.show_checkout_history

# Find overdue books
overdue = library.overdue_books
```

## 🎓 Learning Outcomes

This project demonstrates proficiency in:

- **Object-Oriented Design**: Classes, inheritance, composition, encapsulation
- **Design Patterns**: Factory, Repository, Strategy (via composition)
- **Error Handling**: Custom exceptions, error recovery, validation
- **Data Persistence**: JSON serialization, object reconstruction
- **Ruby Idioms**: Blocks, iterators, safe navigation, predicate methods
- **Code Organization**: Modular design, separation of concerns
- **Testing Mindset**: Comprehensive test scenarios in main.rb

## 📊 Project Stats

- **13** Custom exception classes
- **8+** Main classes
- **50+** Methods
- **12** Ruby files
- **3** Design patterns
- **2** Member type implementations (inheritance & composition)

## 🔮 Future Enhancements

- [ ] Web interface with Sinatra/Rails
- [ ] Database integration (SQLite/PostgreSQL)
- [ ] Unit tests (RSpec)
- [ ] Book reservations/waiting list
- [ ] Late fee calculation
- [ ] Email notifications
- [ ] Multi-library support
- [ ] Book ratings and reviews
- [ ] Export to CSV/PDF reports

## 👨‍💻 Author

**Your Name**
- GitHub: [@rifah07](https://github.com/rifah07)
- LinkedIn: [Rifah Sajida Deya](https://www.linkedin.com/in/rifah-sajida-deya-1011/)
- Email: rifahsajida7@gmail.com

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

Built as a learning project to master Ruby OOP concepts and design patterns.

---

⭐ If you found this project helpful, please consider giving it a star!