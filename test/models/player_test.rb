require "test_helper"
require "minitest/mock"

class PlayerTest < ActiveSupport::TestCase
  test "admin cannot be suspended" do
    admin = players(:one)
    original_token = admin.remember_token

    assert_raises ActiveRecord::RecordInvalid do
      admin.suspend!(by: players(:one))
    end
    assert_includes admin.errors[:suspended], "cannot be enabled for an admin"
    assert_not admin.reload.suspended?
    assert_equal original_token, admin.remember_token
  end

  test "suspended user cannot be promoted to admin" do
    player = players(:two)
    player.suspend!(by: players(:one))

    assert_not player.update(admin: true)
    assert_includes player.errors[:suspended], "cannot be enabled for an admin"
    assert_not player.reload.admin?
    assert player.suspended?
  end

  test "new admin cannot be created suspended" do
    player = Player.new(first_name: "New", last_name: "Admin",
      email: "new-suspended-admin@example.com", password: "password123", admin: true, suspended: true)

    assert_not player.save
    assert_includes player.errors[:suspended], "cannot be enabled for an admin"
  end

  test "suspension and restoration record the target and acting admin" do
    player = players(:two)
    admin = players(:one)

    assert_difference "UserSuspensionEvent.count", 1 do
      player.suspend!(by: admin)
    end
    event = UserSuspensionEvent.last
    assert_equal player.id, event.player_id
    assert_equal admin.id, event.admin_id
    assert_equal "suspended", event.action
    assert event.created_at.present?

    assert_difference "UserSuspensionEvent.count", 1 do
      player.restore!(by: admin)
    end
    assert_equal "restored", UserSuspensionEvent.last.action
  end

  test "repeated suspension or restoration does not create duplicate events" do
    player = players(:two)
    admin = players(:one)
    player.suspend!(by: admin)
    assert_no_difference "UserSuspensionEvent.count" do
      player.suspend!(by: admin)
    end
    player.restore!(by: admin)
    assert_no_difference "UserSuspensionEvent.count" do
      player.restore!(by: admin)
    end
  end

  test "suspension changes require an active admin even through a direct update" do
    player = players(:two)
    assert_no_difference "UserSuspensionEvent.count" do
      assert_not player.update(suspended: true)
      assert_not player.update(suspended: true, suspension_admin: player)
    end
    assert_not player.reload.suspended?

    player.suspend!(by: players(:one))
    assert_not player.update(suspended: false)
    assert player.reload.suspended?
  end

  test "audit failure rolls back the suspension and session token change" do
    player = players(:two)
    token = player.remember_token
    failure = ->(*) { raise ActiveRecord::RecordInvalid.new(UserSuspensionEvent.new) }

    assert_no_difference "UserSuspensionEvent.count" do
      UserSuspensionEvent.stub :create!, failure do
        assert_raises ActiveRecord::RecordInvalid do
          player.suspend!(by: players(:one))
        end
      end
    end
    assert_not player.reload.suspended?
    assert_equal token, player.remember_token
  end

  test "audit entries remain when the user is deleted" do
    player = Player.create!(first_name: "Deleted", last_name: "Player",
      email: "deleted-audit-player@example.com", password: "password123")
    player.suspend!(by: players(:one))
    event = UserSuspensionEvent.last
    player.destroy!

    assert_equal player.id, event.reload.player_id
    assert_equal players(:one).id, event.admin_id
  end
end
