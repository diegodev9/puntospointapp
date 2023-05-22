# frozen_string_literal: true

# user controller
class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: :show

  def purchases
    @pagy, @purchases = pagy(Purchase.by_client(current_user.id))
  end

  def show
    render json: @user
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
