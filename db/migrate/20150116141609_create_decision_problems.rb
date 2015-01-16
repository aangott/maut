class CreateDecisionProblems < ActiveRecord::Migration
  def change
    create_table :decision_problems do |t|
      t.text :description

      t.timestamps
    end
  end
end
