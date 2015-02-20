class Dimension < ActiveRecord::Base
  default_scope order('rank')

  belongs_to :decision_problem
end
