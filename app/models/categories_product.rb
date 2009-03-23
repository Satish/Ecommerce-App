class CategoriesProduct < ActiveRecord::Base
  
  validates_presence_of :category_id#, :product_id
  validates_uniqueness_of :category_id, :scope =>  :product_id
  
  belongs_to :product
  belongs_to :category
  
end
