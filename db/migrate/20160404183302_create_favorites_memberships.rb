class CreateFavoritesMemberships < ActiveRecord::Migration
  def change
    create_table :favorites_memberships do |t|

      t.timestamps null: false
    end
  end
end
