class CreateSkills < ActiveRecord::Migration[5.0]
  def change
    create_table :skills do |t|
      t.string :name
      t.boolean :proficient
      t.integer :bonus
      t.belongs_to :character

      t.timestamps
    end
  end
end
