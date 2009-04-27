# == Schema Information
#
# Table name: attribute_values
#
#  id                   :integer(4)      not null, primary key
#  value                :string(255)
#  sku_id               :integer(4)
#  product_attribute_id :integer(4)
#  active               :boolean(1)      default(TRUE)
#  created_at           :datetime
#  updated_at           :datetime
#

class AttributeValue < ActiveRecord::Base

  @@per_page = PER_PAGE
  cattr_reader :per_page

  validates_presence_of :value, :product_attribute_id#, :sku_id
  validates_uniqueness_of :value, :scope => [:sku_id, :product_attribute_id]

  belongs_to :sku
  belongs_to :product_attribute

end
