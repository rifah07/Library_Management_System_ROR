# frozen_string_literal: true
require_relative 'Member'

class RegularMember < Member
  CHECKOUT_LIMIT = 3
  CHECKOUT_DAYS = 14

  def member_type
    'Regular Member'
  end
end

