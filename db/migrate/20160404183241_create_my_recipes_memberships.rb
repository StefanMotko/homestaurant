class CreateMyRecipesMemberships < ActiveRecord::Migration
  def change
    create_table :my_recipes_memberships do |t|

      t.timestamps null: false
    end
  end
end
