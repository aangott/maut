class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.text :description
      t.references :decision_problem

      t.timestamps
    end
    add_index :options, :decision_problem_id
  end
end
