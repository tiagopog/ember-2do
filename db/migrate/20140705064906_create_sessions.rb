class CreateSessions < ActiveRecord::Migration
  def change
    create_table :sessions do |t|
      t.references :user, index: true
      t.string :access_token
      t.datetime :expires_at

      t.timestamps
    end

    add_index :sessions, [:access_token, :expires_at]
  end
end
