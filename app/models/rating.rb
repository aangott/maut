class Rating < ActiveRecord::Base
  belongs_to :dimension
  belongs_to :option

  def option_description
    option.description
  end
end
