class CreateTraits < ActiveRecord::Migration[5.0]
  def change
    create_table :traits do |t|
      t.string :name
      t.integer :value
      t.integer :modifier
      t.belongs_to :character

      t.timestamps
    end
  end
end
