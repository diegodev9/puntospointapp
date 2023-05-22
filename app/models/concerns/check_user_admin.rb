module CheckUserAdmin
  extend ActiveSupport::Concern

  def check_user_admin
    user_admin = User.find(user_id).level
    throw :abort unless user_admin == 'admin'
  end
end
