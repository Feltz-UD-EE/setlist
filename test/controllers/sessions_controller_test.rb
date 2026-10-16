require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @player = Player.create!(first_name: "Login", last_name: "Tester",
      email: "suspension-login@example.com", password: "password123")
  end

  test "existing and new users are not suspended by default" do
    assert_not @player.suspended?
    assert_not players(:one).suspended?
    assert_not players(:two).suspended?
    assert_not Player.columns_hash.fetch("suspended").null
  end

  test "normal user can sign in" do
    log_in
    assert_response :redirect
    get public_home_url
    assert_select ".session-links", text: /#{Regexp.escape(@player.email)}/
  end

  test "suspended login redirects to the suspension message without signing in" do
    @player.suspend!(by: players(:one))
    log_in

    assert_redirected_to suspended_account_url
    follow_redirect!
    assert_response :success
    assert_equal "Your account has been suspended for violation of the site Terms of Service", response.body

    get players_url
    assert_redirected_to sign_in_url
  end

  test "wrong password still produces the normal login error" do
    @player.suspend!(by: players(:one))
    log_in(password: "incorrect")
    assert_response :unauthorized
    assert_select "input[name=?]", "session[password]"
  end

  test "suspension revokes existing sessions and restore requires a fresh login" do
    log_in
    @player.suspend!(by: players(:one))

    get players_url
    assert_redirected_to sign_in_url

    @player.restore!(by: players(:one))
    get players_url
    assert_redirected_to sign_in_url

    log_in
    get public_home_url
    assert_select ".session-links", text: /#{Regexp.escape(@player.email)}/
  end

  test "suspended state is enforced even when set without rotating the session token" do
    log_in
    @player.update!(suspended: true, suspension_admin: players(:one))

    get public_home_url
    assert_redirected_to suspended_account_url
    follow_redirect!
    assert_response :success

    get players_url
    assert_redirected_to sign_in_url
  end

  test "password reset cannot sign a suspended user in" do
    @player.suspend!(by: players(:one))
    @player.forgot_password!
    get edit_player_password_url(@player, token: @player.confirmation_token)
    follow_redirect!
    assert_response :success

    put player_password_url(@player), params: { password_reset: { password: "new-password456" } }
    assert_response :redirect
    assert @player.reload.suspended?
    assert @player.authenticated?("new-password456")

    get players_url
    assert_redirected_to sign_in_url
    log_in(password: "new-password456")
    assert_redirected_to suspended_account_url
  end

  private

  def log_in(password: "password123")
    post session_url, params: { session: { email: @player.email, password: password } }
  end
end
