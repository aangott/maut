class DecisionProblem < ActiveRecord::Base

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

  def setup_ratings
    options.each do |option|
      dimensions.each do |dimension|
        option.ratings.where(dimension_id: dimension.id).first_or_create
      end
    end
  end

  # make sure rating values conform to ranks when ranks change
  def update_ratings_by_rank
    dimensions.each do |dimension|
      dim_ratings = dimension.ratings.sort_by(&:rank)
      dim_ratings.first.update_attribute(:value, 100)
      dim_ratings.last.update_attribute(:value, 0)
    end
  end

  # make sure option ranks conform to rating values when values change
  def update_ratings_by_value
    dimensions.each do |dimension|
      dim_ratings = dimension.ratings.sort_by(&:value).reverse
      dim_ratings.each_with_index do |rating, idx|
        rating.update_attribute(:rank, idx + 1)
      end
    end
  end

  def update_dimension_weights_by_rank
    dims_by_rank = dimensions.sort_by(&:rank)
    dims_by_rank.first.update_attribute(:weight, 100)
    dims_by_rank.last.update_attribute(:weight, 10)
  end

  def dimensions_json
    dimensions.to_json(include: { sorted_ratings: { methods: :option_description } })
  end

  def sorted_dimensions
    dims_with_rank, dims_no_rank = dimensions.partition { |d| d.rank.present? }
    dims_with_rank.sort_by(&:rank) + dims_no_rank
  end

  def option_scores_json
    options.sort_by(&:score).to_json(methods: :score)
  end

end
