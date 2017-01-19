class CreatePersonalityTraits < ActiveRecord::Migration[5.0]
  def change
    create_table :personality_traits do |t|
      t.integer :roll
      t.string :description

      t.timestamps
    end
  end
end
