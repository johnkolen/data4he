class CreateStoryNotes < ActiveRecord::Migration[8.0]
  def change
    create_table :story_notes do |t|
      t.string :note, default: ""
      t.string :author, default: ""
      t.references :story_task, null: false, foreign_key: true

      t.timestamps
    end
  end
end
