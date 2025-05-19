class CreateHouses < ActiveRecord::Migration[8.0]
  def change
    create_table :houses do |t|
      t.string :name
      t.date :build_date
      t.integer :age

      t.timestamps
    end
  end
end
