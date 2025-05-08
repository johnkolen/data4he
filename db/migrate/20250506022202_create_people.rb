class CreatePeople < ActiveRecord::Migration[8.0]
  def change
    create_table :people do |t|
      t.string :first_name_h
      t.string :last_name_h
      t.date :date_of_birth_h
      t.string :ssn_h

      t.timestamps
    end
  end
end
