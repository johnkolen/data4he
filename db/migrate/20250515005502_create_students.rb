class CreateStudents < ActiveRecord::Migration[8.0]
  def change
    create_table :students do |t|
      t.string :inst_id
      t.references :person, null: false, foreign_key: true
      t.references :catalog_year,
                   null: false,
                   foreign_key: { to_table: :academic_years }

      t.timestamps
    end
  end
end
