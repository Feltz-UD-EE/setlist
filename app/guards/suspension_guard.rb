class SuspensionGuard < Clearance::SignInGuard
  def call
    if current_user&.suspended?
      failure("Your account has been suspended for violation of the site Terms of Service")
    else
      next_guard
    end
  end
end
