class Dimension < ActiveRecord::Base
  default_scope order('rank')

  belongs_to :decision_problem
  has_many :ratings
  has_many :options, through: :ratings

  def best_option
    sorted_ratings = ratings.select { |r| r.value.present? }.sort_by(&:value)
    return unless sorted_ratings.any?
    sorted_ratings.first.option
  end

  def worst_option
    sorted_ratings = ratings.select { |r| r.value.present? }.sort_by(&:value)
    return unless sorted_ratings.any?
    sorted_ratings.last.option
  end

  def least_important_dimension
    # max rank = least important, where most important gets rank of 1
    max_rank = dimensions.map(&:rank).max
    return unless max_rank
    dimensions.detect { |d| d.rank == max_rank }
  end








end
