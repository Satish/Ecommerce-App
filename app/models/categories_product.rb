# == Schema Information
#
# Table name: categories_products
#
#  id          :integer(4)      not null, primary key
#  category_id :integer(4)
#  product_id  :integer(4)
#  active      :boolean(1)      default(TRUE)
#  created_at  :datetime
#  updated_at  :datetime
#

class CategoriesProduct < ActiveRecord::Base
  
  validates_presence_of :category_id#, :product_id
  validates_uniqueness_of :category_id, :scope =>  :product_id
  
  belongs_to :product
  belongs_to :category
  
end
