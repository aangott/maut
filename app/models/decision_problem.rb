class DecisionProblem < ActiveRecord::Base
  has_many :options
  has_many :dimensions

  accepts_nested_attributes_for :dimensions,
                                allow_destroy: true,
                                reject_if: :description_blank

  accepts_nested_attributes_for :options,
                                allow_destroy: true,
                                reject_if: :description_blank

  MINIMUM_DIMENSIONS_COUNT = 1
  MINIMUM_OPTIONS_COUNT = 2

  def description_blank(attribs)
    attribs[:description].blank?
  end

  def setup_ratings
    options.each do |option|
      dimensions.each do |dimension|
        option.ratings.where(dimension_id: dimension.id).first_or_create
      end
    end
  end

end
