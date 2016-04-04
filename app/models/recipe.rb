class Recipe < ActiveRecord::Base
  belongs_to :user
  has_many :comments
  has_many :my_recipes_memberships
  has_many :favorites_memberships
  has_many :recipe_ratings
  has_many :components
end
