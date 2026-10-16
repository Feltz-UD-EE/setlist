class AccountSuspensionsController < ApplicationController
  skip_before_action :require_login

  def show
    render plain: "Your account has been suspended for violation of the site Terms of Service"
  end
end
