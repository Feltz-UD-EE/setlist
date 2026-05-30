module Clearance
  class PasswordsController < Clearance::BaseController
    def create
      @user = find_user_by_email_token
      if @user.update(password_params)
        @user.send_password_reset_email  # Add this line
        sign_in @user
        redirect_to url_after_password_reset
      else
        render :new
      end
    end

    private

    def find_user_by_email_token
      Clearance.configuration.user_model.find_by(
        email_confirmation_token: email_token
      )
    end

    def password_params
      params.require(:password).permit(:password, :password_confirmation)
    end

    def email_token
      params[:user_id]
    end
  end
end