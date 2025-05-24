class CreateStoryTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :story_tasks do |t|
      t.string :title, default: "Title"
      t.string :description, default: "Description"
      t.integer :priority, default: 0
      t.integer :status_id, default: 0

      t.timestamps
    end
  end
end
