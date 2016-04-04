class CreateIngredientRatings < ActiveRecord::Migration
  def change
    create_table :ingredient_ratings do |t|
      t.integer :rating
      t.datetime :expiration

      t.timestamps null: false
    end
  end
end
