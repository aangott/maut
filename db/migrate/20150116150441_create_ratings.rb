class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :value
      t.references :dimension
      t.references :option

      t.timestamps
    end
    add_index :ratings, :dimension_id
    add_index :ratings, :option_id
  end
end
