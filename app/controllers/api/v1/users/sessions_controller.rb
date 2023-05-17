# frozen_string_literal: true

module Api
  module V1
    module Users
      # api/v1/session controller
      class SessionsController < Devise::SessionsController
        # before_action :configure_sign_in_params, only: [:create]
        respond_to :json

        # GET /resource/sign_in
        # def new
        #   super
        # end

        # POST /resource/sign_in
        # def create
        #   super
        # end

        # DELETE /resource/sign_out
        def destroy
          super do
            return redirect_to after_sign_out_path_for(resource_name), status: :see_other, notice: 'cerraste sesion'
          end
        end

        private

        def respond_with(_resource, _opts = {})
          render json: { message: 'You are logged in.' }, status: :ok
        end

        def respond_to_on_destroy
          log_out_success && return if current_user

          log_out_failure
        end

        def log_out_success
          render json: { message: 'You are logged out.' }, status: :ok
        end

        def log_out_failure
          render json: { message: 'Hmm nothing happened.' }, status: :unauthorized
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