class AddInviteeDetailsToBandInvitations < ActiveRecord::Migration[8.0]
  def change
    add_column :band_invitations, :invitee_name, :string
    add_column :band_invitations, :invitee_email, :string
  end
end
