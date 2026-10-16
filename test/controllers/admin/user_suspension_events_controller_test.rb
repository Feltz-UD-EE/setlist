require "test_helper"

class Admin::UserSuspensionEventsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = Player.create!(first_name: "Audit", last_name: "Admin",
      email: "audit-admin@example.com", password: "password123", admin: true)
    @player = Player.create!(first_name: "Audit", last_name: "Player",
      email: "audit-player@example.com", password: "password123")
  end

  test "admins can follow the management page link to an empty audit log" do
    sign_in_as(@admin)
    get admin_user_password_controls_url
    assert_select "a[href=?]", admin_user_suspension_events_path, text: "Suspension audit log"

    get admin_user_suspension_events_url
    assert_response :success
    assert_select "h1", "Suspension audit log"
    assert_select "thead th", count: 4
    assert_select "p", "No suspension or restoration events have been recorded."
    assert_select "a[href=?]", admin_user_password_controls_path
  end

  test "audit table shows both actions with timestamps and admin and user ids newest first" do
    sign_in_as(@admin)
    suspended_at = Time.utc(2026, 10, 16, 12, 0, 0)
    restored_at = suspended_at + 1.hour

    travel_to suspended_at do
      assert_difference "UserSuspensionEvent.count", 1 do
        post suspend_admin_user_password_control_url(@player)
      end
      assert_redirected_to admin_user_password_controls_url
    end
    travel_to restored_at do
      assert_difference "UserSuspensionEvent.count", 1 do
        post restore_admin_user_password_control_url(@player)
      end
      assert_redirected_to admin_user_password_controls_url
    end

    get admin_user_suspension_events_url
    assert_response :success
    assert_select "tbody tr", count: 2
    assert_select "tbody tr:first-child" do
      assert_select "td", text: restored_at.iso8601(6)
      assert_select "td", text: @player.id.to_s
      assert_select "td", text: @admin.id.to_s
      assert_select "td", text: "Restored"
    end
    assert_select "tbody tr:last-child" do
      assert_select "td", text: suspended_at.iso8601(6)
      assert_select "td", text: @player.id.to_s
      assert_select "td", text: @admin.id.to_s
      assert_select "td", text: "Suspended"
    end
  end

  test "anonymous visitors cannot access the audit log" do
    get admin_user_suspension_events_url
    assert_redirected_to sign_in_url
  end

  test "regular users cannot access the audit log" do
    sign_in_as(@player)
    get admin_user_suspension_events_url
    assert_response :forbidden
  end

  test "rejected admin suspension requests do not create audit entries" do
    sign_in_as(@admin)
    assert_no_difference "UserSuspensionEvent.count" do
      post suspend_admin_user_password_control_url(@admin)
    end
    assert_response :forbidden
  end

  private

  def sign_in_as(player)
    post session_url, params: { session: { email: player.email, password: "password123" } }
    assert_response :redirect
  end
end
