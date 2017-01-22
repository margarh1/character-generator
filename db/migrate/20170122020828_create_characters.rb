class CreateCharacters < ActiveRecord::Migration[5.0]
  def change
    create_table :characters do |t|
      t.string :name
      t.integer :level
      t.integer :exp
      t.string :class
      t.string :race
      t.string :background

      t.timestamps
    end
  end
end
