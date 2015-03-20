class AddRankToRatings < ActiveRecord::Migration
  def change
    add_column :ratings, :rank, :integer
  end
end
