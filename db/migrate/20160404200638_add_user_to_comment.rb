# Added other associations as well. Renaming caused errors, so I reverted to original name.
class AddUserToComment < ActiveRecord::Migration
  def change
    add_reference :comments, :user, index: true, foreign_key: true
    add_reference :comments, :recipe, index: true, foreign_key: true

    add_reference :components, :ingredient, index: true, foreign_key: true
    add_reference :components, :recipe, index: true, foreign_key: true

    add_reference :favorites_memberships, :user, index: true, foreign_key: true
    add_reference :favorites_memberships, :recipe, index: true, foreign_key: true

    add_reference :ingredient_ratings, :user, index: true, foreign_key: true
    add_reference :ingredient_ratings, :ingredient, index: true, foreign_key: true

    add_reference :my_recipes_memberships, :user, index: true, foreign_key: true
    add_reference :my_recipes_memberships, :recipe, index: true, foreign_key: true

    add_reference :recipe_ratings, :user, index: true, foreign_key: true
    add_reference :recipe_ratings, :recipe, index: true, foreign_key: true
  end
end
