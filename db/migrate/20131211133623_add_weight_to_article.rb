class AddWeightToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :weight, :integer
  end
end
