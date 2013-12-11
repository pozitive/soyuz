class AddAncestryToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :ancestry, :string
    add_index :articles, :ancestry
  end
end
