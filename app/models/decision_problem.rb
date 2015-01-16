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
    attribs[:desription].blank?
  end







end
