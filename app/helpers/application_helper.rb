# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def list_categories_for_navbar
    Category.list_all_categories
  end
end
