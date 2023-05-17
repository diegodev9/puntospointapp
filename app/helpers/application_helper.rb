# frozen_string_literal: true

# application helper
module ApplicationHelper
  include Pagy::Frontend

  def list_categories_for_navbar
    Category.list_all_categories
  end
end

# to_boolean class string
class String
  def to_boolean
    ActiveRecord::Type::Boolean.new.cast(self)
  end
end
