class Option < ActiveRecord::Base
  belongs_to :decision_problem
  has_many :ratings, dependent: :destroy
  has_many :dimensions, through: :ratings

  accepts_nested_attributes_for :ratings

  before_validation :strip_whitespace

  def score
    ratings.map { |rating| rating.value * rating.dimension.weight }.reduce(:+)
  end

  def strip_whitespace
    self.description = self.description.try(:strip)
  end
  private :strip_whitespace
end
