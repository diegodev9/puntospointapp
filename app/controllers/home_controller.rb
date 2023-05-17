# frozen_string_literal: true

# home controller
class HomeController < ApplicationController
  def index
    @pagy, @categories = pagy(Category.includes([:products], products: [:pictures_attachments]).list_all_categories)
  end
end
