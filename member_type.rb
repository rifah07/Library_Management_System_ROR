# frozen_string_literal: true

# Composition = "HAS-A" relationship (Member HAS-A MemberType)
# Inheritance = "IS-A" relationship (Student IS-A Member)

# Base class defining member type behavior
class MemberType
  attr_reader :name, :checkout_days, :checkout_limit

  def initialize(name, checkout_limit, checkout_days)
    @name = name
    @checkout_days = checkout_days
    @checkout_limit = checkout_limit
  end
end


# Specific member types
class StudentType < MemberType
  def initialize
    super('Student', 2, 14)
  end
end

class FacultyType < MemberType
  def initialize
    super('Faculty', 5, 30)
  end
end

class RegularMemberType < MemberType
  def initialize
    super('Regular Member', 3, 14)
  end
end