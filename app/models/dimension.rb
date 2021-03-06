class Dimension < ActiveRecord::Base
  default_scope order('rank')

  belongs_to :decision_problem
  has_many :ratings, dependent: :destroy
  has_many :options, through: :ratings

  validates :description, uniqueness: { scope: :decision_problem_id }

  before_validation :strip_whitespace

  def sorted_ratings
    ratings_with_rank, ratings_no_rank = ratings.partition { |r| r.rank.present? }
    ratings_with_rank.sort_by(&:rank) + ratings_no_rank
  end

  def strip_whitespace
    self.description = self.description.try(:strip)
  end
  private :strip_whitespace
end
