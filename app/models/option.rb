class Option < ActiveRecord::Base
  belongs_to :decision_problem
  has_many :ratings
  has_many :dimensions, through: :ratings
end
