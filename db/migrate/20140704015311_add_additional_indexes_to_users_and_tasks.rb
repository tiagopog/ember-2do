class AddAdditionalIndexesToUsersAndTasks < ActiveRecord::Migration
  def change
    add_index :users, :token
    add_index :tasks, [:priority, :project_id]
    add_index :tasks, [:done, :project_id]
  end
end
