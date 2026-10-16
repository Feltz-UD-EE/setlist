class SessionsController < Clearance::SessionsController
  def create
    @user = authenticate(params)

    sign_in(@user) do |status|
      if @user&.suspended?
        redirect_to suspended_account_path, status: :see_other
      elsif status.success?
        redirect_back_or url_after_create
      else
        flash.now.alert = status.failure_message
        render template: "sessions/new", status: :unauthorized
      end
    end
  end
end
