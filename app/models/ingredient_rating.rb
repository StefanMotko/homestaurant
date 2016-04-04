class IngredientRating < ActiveRecord::Base
  belongs_to :ingredient
  belongs_to :user
end
