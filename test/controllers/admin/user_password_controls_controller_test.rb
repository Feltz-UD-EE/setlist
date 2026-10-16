require "test_helper"
require "uri"

class Admin::UserPasswordControlsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = Player.create!(first_name: "Site", last_name: "Admin",
      email: "control-admin@example.com", password: "password123", admin: true)
    @player = Player.create!(first_name: "Regular", last_name: "Player",
      email: "control-player@example.com", password: "password123")
    @band = Band.create!(name: "Control Band")
    @other_band = Band.create!(name: "Other Control Band")
    @player.bands << @band
    @player.update!(band: @other_band)
  end

  test "anonymous visitors cannot see the footer link or access management" do
    get public_home_url
    assert_select "footer a[href=?]", admin_user_password_controls_path, count: 0

    get admin_user_password_controls_url
    assert_redirected_to sign_in_url

    assert_no_emails do
      post reset_password_admin_user_password_control_url(@player)
    end
    assert_redirected_to sign_in_url
    assert_nil @player.reload.confirmation_token
  end

  test "non admins cannot see the footer link or access management" do
    sign_in_as(@player)
    get public_home_url
    assert_select "footer a[href=?]", admin_user_password_controls_path, count: 0

    get admin_user_password_controls_url
    assert_response :forbidden
    assert_not_includes response.body, @admin.email

    assert_no_emails do
      post reset_password_admin_user_password_control_url(@admin)
    end
    assert_response :forbidden
    assert_nil @admin.reload.confirmation_token
  end

  test "admins see all users with linked bands and both action buttons" do
    sign_in_as(@admin)
    get admin_user_password_controls_url

    assert_response :success
    assert_select "h1", "User and password control"
    assert_select "footer a[href=?]", admin_user_password_controls_path
    assert_select "thead th", text: "User id"
    assert_select "thead th", text: "User email"
    assert_select "thead th", text: "Bands"
    assert_select "thead th", text: "Actions"
    assert_select "tbody tr", count: Player.count
    assert_select "form[action=?]", suspend_admin_user_password_control_path(@admin), count: 0
    assert_select "tbody tr", text: /#{Regexp.escape(@player.email)}/ do
      assert_select "td", text: @player.id.to_s
      assert_select "a[href=?]", band_path(@band), text: @band.name
      assert_select "a[href=?]", band_path(@other_band), text: @other_band.name
      assert_select "form[action=?][method=post]", reset_password_admin_user_password_control_path(@player) do
        assert_select "button", "Reset password"
      end
      assert_select "form[action=?][method=post]", suspend_admin_user_password_control_path(@player) do
        assert_select "button", "Suspend user"
      end
    end
  end

  test "admin reset sends a one time link that updates the password" do
    sign_in_as(@admin)
    original_password = @player.encrypted_password

    assert_emails 1 do
      post reset_password_admin_user_password_control_url(@player)
    end
    assert_redirected_to admin_user_password_controls_url
    assert_equal original_password, @player.reload.encrypted_password
    token = @player.confirmation_token
    assert token.present?

    email = ActionMailer::Base.deliveries.last
    assert_equal [ @player.email ], email.to
    body = email.html_part ? email.html_part.body.decoded : email.body.decoded
    link = Nokogiri::HTML(body).at_css("a")["href"]
    uri = URI.parse(link)
    assert_equal edit_player_password_path(@player), uri.path
    assert_equal token, URI.decode_www_form(uri.query).to_h.fetch("token")

    recipient = open_session
    recipient.get link
    assert recipient.response.redirect?
    recipient.follow_redirect!
    assert_equal 200, recipient.response.status
    assert_includes recipient.response.body, "password_reset[password]"

    assert_no_emails do
      recipient.put player_password_path(@player), params: { password_reset: { password: "new-password456" } }
    end
    assert recipient.response.redirect?
    assert_nil @player.reload.confirmation_token
    assert @player.authenticated?("new-password456")
    assert_not @player.authenticated?("password123")

    replay = open_session
    replay.get link
    assert_equal 422, replay.response.status
    replay.put player_password_path(@player), params: {
      token: token, password_reset: { password: "replayed-password789" }
    }
    assert_equal 422, replay.response.status
    assert @player.reload.authenticated?("new-password456")
  end

  test "requesting another reset invalidates the previous link" do
    sign_in_as(@admin)
    post reset_password_admin_user_password_control_url(@player)
    old_token = @player.reload.confirmation_token

    post reset_password_admin_user_password_control_url(@player)
    assert_not_equal old_token, @player.reload.confirmation_token

    recipient = open_session
    recipient.get edit_player_password_path(@player, token: old_token)
    assert_equal 422, recipient.response.status
  end

  test "admins can suspend and restore a user" do
    sign_in_as(@admin)
    old_token = @player.remember_token
    post suspend_admin_user_password_control_url(@player)

    assert_redirected_to admin_user_password_controls_url
    assert @player.reload.suspended?
    assert_not_equal old_token, @player.remember_token
    follow_redirect!
    assert_select "tr.suspended-user", text: /#{Regexp.escape(@player.email)}/ do
      assert_select "form[action=?]", restore_admin_user_password_control_path(@player) do
        assert_select "button", "Restore user"
      end
      assert_select "form[action=?]", suspend_admin_user_password_control_path(@player), count: 0
    end

    post restore_admin_user_password_control_url(@player)

    assert_redirected_to admin_user_password_controls_url
    assert_not @player.reload.suspended?
    follow_redirect!
    assert_select "tr.suspended-user", text: /#{Regexp.escape(@player.email)}/, count: 0
    assert_select "form[action=?]", suspend_admin_user_password_control_path(@player)
  end

  test "anonymous visitors cannot suspend or restore users" do
    post suspend_admin_user_password_control_url(@player)
    assert_redirected_to sign_in_url
    assert_not @player.reload.suspended?

    @player.suspend!(by: players(:one))
    post restore_admin_user_password_control_url(@player)
    assert_redirected_to sign_in_url
    assert @player.reload.suspended?
  end

  test "non admins cannot suspend or restore users" do
    sign_in_as(@player)
    post suspend_admin_user_password_control_url(@admin)
    assert_response :forbidden
    assert_not @admin.reload.suspended?

    suspended_player = players(:two)
    suspended_player.suspend!(by: players(:one))
    post restore_admin_user_password_control_url(suspended_player)
    assert_response :forbidden
    assert suspended_player.reload.suspended?
  end

  test "admins cannot suspend themselves or another admin through a direct request" do
    sign_in_as(@admin)

    [ @admin, players(:one) ].each do |admin|
      original_token = admin.remember_token
      post suspend_admin_user_password_control_url(admin)

      assert_response :forbidden
      assert_not admin.reload.suspended?
      assert_equal original_token, admin.remember_token
    end
  end

  private

  def sign_in_as(player)
    post session_url, params: { session: { email: player.email, password: "password123" } }
    assert_response :redirect
  end
end
