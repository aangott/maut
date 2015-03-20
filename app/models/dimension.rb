class Dimension < ActiveRecord::Base
  default_scope order('rank')

  belongs_to :decision_problem
  has_many :ratings
  has_many :options, through: :ratings

  def least_important_dimension
    # max rank = least important, where most important gets rank of 1
    max_rank = dimensions.map(&:rank).max
    return unless max_rank
    dimensions.detect { |d| d.rank == max_rank }
  end

  def sorted_ratings
    ratings_with_rank, ratings_no_rank = ratings.partition { |r| r.rank.present? }
    ratings_with_rank.sort_by(&:rank) + ratings_no_rank
  end

end
