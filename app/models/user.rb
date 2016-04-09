class User < ActiveRecord::Base
  has_many :recipes
  has_many :comments
  has_many :my_recipes_memberships
  has_many :favorites_memberships
  has_many :recipe_ratings
  has_many :ingredient_ratings

  validates :username, length: {minimum: 3, maximum: 40}
  validates :email, length: {maximum: 255}

  validates_uniqueness_of :username
  validates_format_of :email,:with => /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/

  has_secure_password
  validates :password, presence: true, length: {minimum: 6}
end
