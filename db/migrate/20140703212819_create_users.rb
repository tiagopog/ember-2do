class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.text :token
      t.string :avatar_url

      t.timestamps
    end
  end
end
