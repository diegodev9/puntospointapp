# frozen_string_literal: true

module Api
  module V1
    module Users
      # api/v1/session controller
      class SessionsController < Devise::SessionsController
        include RackSessionFix
        before_action :set_user
        # before_action :configure_sign_in_params, only: [:create]
        respond_to :json

        def create
          if @user.present? && @user.level == 'admin'
            if sign_in(@user)
              render json: {
                status: { code: 200, message: 'Logged in successfully.' },
                data: @user
              }, status: :ok
            else
              render json: { message: 'no estas autorizado' }, status: :unauthorized
            end
          end
        end

        private

        def respond_with(resource, _opts = {})
        end

        def respond_to_on_destroy
          if current_user
            render json: {
              status: 200,
              message: 'logged out successfully'
            }, status: :ok
          else
            render json: {
              status: 401,
              message: "Couldn't find an active session."
            }, status: :unauthorized
          end
        end

        def log_out_success
          render json: { message: 'Logged out.' }, status: :ok
        end

        def log_out_failure
          render json: { message: 'Logged out failure.' }, status: :unauthorized
        end

        def set_user
          @user = User.find_by(email: params[:user][:email])
        end

        # protected

        # If you have extra params to permit, append them to the sanitizer.
        # def configure_sign_in_params
        #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
        # end
      end
    end
  end
end
