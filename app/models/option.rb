class Option < ActiveRecord::Base
  belongs_to :decision_problem
  has_many :ratings
  has_many :dimensions, through: :ratings

  accepts_nested_attributes_for :ratings

  def score
    total = 0
    ratings.each do |rating|
      total += (rating.value * rating.dimension.weight)
    end
    total
  end

end
