class CreateCharacters < ActiveRecord::Migration[5.0]
  def change
    create_table :characters do |t|
      t.string :name
      t.string :gender
      t.integer :level
      t.integer :exp
      t.string :character_class
      t.string :race
      t.string :background
      t.belongs_to :user

      t.timestamps
    end
  end
end
