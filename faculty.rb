# frozen_string_literal: true
require_relative 'Member'

class Faculty < Member
  CHECKOUT_LIMIT = 5
  CHECKOUT_DAYS = 30

  def member_type
    'Faculty'
  end

end