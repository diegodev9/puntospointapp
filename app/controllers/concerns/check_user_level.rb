# frozen_string_literal: true

module CheckUserLevel
  extend ActiveSupport::Concern
  def check_user_level
    redirect_to root_path, notice: 'no estas autorizado para hacer esto' unless user_signed_in? && current_user.admin?
  end
end
