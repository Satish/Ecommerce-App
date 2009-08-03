# == Schema Information
#
# Table name: line_items
#
#  id         :integer(4)      not null, primary key
#  order_id   :integer(4)
#  sku_id     :integer(4)
#  quantity   :integer(4)
#  price      :decimal(8, 2)
#  deleted_at :datetime
#  created_at :datetime
#  updated_at :datetime
#

class LineItem < ActiveRecord::Base

  validates_presence_of :sku_id, :price, :quantity
  validates_numericality_of :price, :greater_than_or_equal_to => 0
  validates_numericality_of :quantity, :greater_than_or_equal_to => 1

  belongs_to :order
  belongs_to :sku, :include => [:product]

  def calculate_price(total_size = nil)
    sku.our_price * (total_size || quantity)
  end

  def calculate_handling_fee
    sku ? sku.product.handling_fee * quantity : 0.0
  end

end
