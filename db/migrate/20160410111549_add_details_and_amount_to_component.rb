class AddDetailsAndAmountToComponent < ActiveRecord::Migration
  def change
    add_column :components, :details, :string
    add_column :components, :amount, :string
  end
end
