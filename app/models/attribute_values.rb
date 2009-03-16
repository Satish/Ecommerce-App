# == Schema Information
#
# Table name: attribute_values
#
#  id                   :integer(4)      not null, primary key
#  value                :string(255)
#  sku_id               :integer(4)
#  product_attribute_id :integer(4)
#  status               :boolean(1)      default(TRUE)
#  created_at           :datetime
#  updated_at           :datetime
#

class AttributeValues < ActiveRecord::Base
  
  validates_presence_of :value, :sku_id, :product_attribute_id
  validates_uniqueness_of :value, :scope => [:sku_id, :product_attribute_id]

  belongs_to :sku, :product_attribute

end