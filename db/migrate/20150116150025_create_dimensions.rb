class CreateDimensions < ActiveRecord::Migration
  def change
    create_table :dimensions do |t|
      t.text :description
      t.integer :rank
      t.integer :weight
      t.references :decision_problem

      t.timestamps
    end
    add_index :dimensions, :decision_problem_id
  end
end
