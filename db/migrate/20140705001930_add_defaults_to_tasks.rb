class AddDefaultsToTasks < ActiveRecord::Migration
  def change
    change_column :tasks, :done, :boolean, default: false
    change_column :tasks, :priority, :integer, default: 2
  end
end
