class CreateFlaws < ActiveRecord::Migration[5.0]
  def change
    create_table :flaws do |t|
      t.integer :roll
      t.string :description

      t.timestamps
    end
  end
end
