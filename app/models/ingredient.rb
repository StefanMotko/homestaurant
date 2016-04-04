class Ingredient < ActiveRecord::Base
  has_many :ingredient_ratings
  has_many :components
end
