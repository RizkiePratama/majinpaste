class AddVisibilityToPastes < ActiveRecord::Migration[5.2]
  def change
    add_column :pastes, :visibility, :string, null: false, default: 'public'
    add_column :pastes, :password_digest, :string
  end
end
