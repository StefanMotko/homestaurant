class CreateRecipeRatings < ActiveRecord::Migration
  def change
    create_table :recipe_ratings do |t|
      t.integer :quality
      t.integer :difficulty
      t.integer :time

      t.timestamps null: false
    end
  end
end
