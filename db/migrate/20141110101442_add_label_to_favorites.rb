class AddLabelToFavorites < ActiveRecord::Migration
  def change
    add_column :favorites, :label, :boolean
  end
end
