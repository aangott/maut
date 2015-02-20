class DecisionProblem < ActiveRecord::Base

  after_save :weight_least_important_dimension

  has_many :options
  has_many :dimensions

  accepts_nested_attributes_for :dimensions,
                                allow_destroy: true,
                                reject_if: :description_blank

  accepts_nested_attributes_for :options,
                                allow_destroy: true,
                                reject_if: :description_blank

  MINIMUM_OPTIONS_COUNT = 2
  MINIMUM_DIMENSIONS_COUNT = 1
  MINIMUM_DIMENSION_WEIGHT = 10

  def description_blank(attribs)
    attribs[:id].blank? && attribs[:description].blank?
  end

  def weight_least_important_dimension
    if least_important_dimension.present?
      least_important_dimension.update_attributes(weight: MINIMUM_DIMENSION_WEIGHT)
    end
    return true # since this is a callback
  end

  def least_important_dimension
    # max rank = least important, where most important gets rank of 1
    max_rank = dimensions.map(&:rank).max
    return unless max_rank
    dimensions.detect { |d| d.rank == max_rank }
  end









  def setup_ratings
    options.each do |option|
      dimensions.each do |dimension|
        option.ratings.where(dimension_id: dimension.id).first_or_create
      end
    end
  end

end
