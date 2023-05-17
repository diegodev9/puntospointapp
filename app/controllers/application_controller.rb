# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session # for test with postman. remove for production

  include Pagy::Backend
end
