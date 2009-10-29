# == Schema Information
#
# Table name: shipments
#
#  id                  :integer(4)      not null, primary key
#  order_id            :integer(4)
#  shipping_method_id  :integer(4)
#  shipping_address_id :integer(4)
#  tracking_number     :string(255)
#  cost                :decimal(8, 2)   default(0.0)
#  shipped_at          :datetime
#  deleted_at          :datetime
#  created_at          :datetime
#  updated_at          :datetime
#

class Shipment < ActiveRecord::Base

  delegate :price, :to => :shipping_method, :prefix => true

  validates_presence_of :order_id, :shipping_method_id, :shipping_address_id

  belongs_to :order
  belongs_to :shipping_method
  belongs_to :shipping_address

  accepts_nested_attributes_for :shipping_address

  def after_update
    if shipping_method_id && shipping_method_id_changed?
      order.update_attribute(:shipping_amount, shipping_method_price)
    end
  end

end
