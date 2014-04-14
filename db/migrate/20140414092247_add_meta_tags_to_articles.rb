class AddMetaTagsToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :summary, :string
    add_column :articles, :keyword, :string
  end
end
