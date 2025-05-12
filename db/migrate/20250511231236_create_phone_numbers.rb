class CreatePhoneNumbers < ActiveRecord::Migration[8.0]
  def change
    create_table :phone_numbers do |t|
      t.string :number
      t.boolean :primary, default: true
      t.boolean :active, default: true
      t.references :person, null: false, foreign_key: true

      t.timestamps
    end
  end
end
