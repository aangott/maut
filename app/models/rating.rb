class Rating < ActiveRecord::Base
  belongs_to :dimension
  belongs_to :option
end
