class User < ActiveRecord::Base
  has_many :recipes
  has_many :comments
  has_many :my_recipes_memberships
  has_many :favorites_memberships
  has_many :recipe_ratings
  has_many :ingredient_ratings
  has_secure_password
  validates_uniqueness_of :username
end
