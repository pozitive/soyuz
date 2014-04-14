class Article < ActiveRecord::Base
  has_ancestry
  translates :name, :content
  validates_presence_of :name, :content

  def to_param
    "#{id}-#{permalink}"
  end

end
