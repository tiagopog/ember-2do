class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.references :project, index: true
      t.string :name
      t.text :description
      t.boolean :done
      t.integer :priority

      t.timestamps
    end
  end
end
