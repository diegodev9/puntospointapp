# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    @pagy, @categories = pagy(Category.includes([:products], products: [:pictures_attachments]).list_all_categories)
  end
end
