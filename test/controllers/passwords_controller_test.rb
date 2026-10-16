require "test_helper"

class PasswordsControllerTest < ActionDispatch::IntegrationTest
  test "forgot password link opens the reset request form without signing in" do
    get sign_in_url
    assert_response :success
    assert_select "a[href=?]", new_password_path

    get new_password_url
    assert_response :success
    assert_select "form[action=?]", passwords_path do
      assert_select "input[name=?]", "password[email]"
    end
  end

  test "reset request with no email renders a validation error" do
    post passwords_url, params: { password: { email: "" } }

    assert_response :unprocessable_entity
    assert_select "input[name=?]", "password[email]"
  end
end
