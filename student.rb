# frozen_string_literal: true
require_relative 'Member'
class Student < Member
  CHECKOUT_LIMIT = 2
  CHECKOUT_DAYS = 14

  def member_type
    'Student'
  end

end