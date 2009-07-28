# == Schema Information
#
# Table name: gateway_options
#
#  id               :integer(4)      not null, primary key
#  name             :string(255)
#  store_gateway_id :integer(4)
#  description      :text
#  created_at       :datetime
#  updated_at       :datetime
#

class GatewayOption < ActiveRecord::Base

  attr_protected :store_gateway_id

  validates_presence_of :name, :store_gateway_id
  validates_uniqueness_of :name, :scope => :store_gateway_id

  has_one :gateway_option_value
  belongs_to :store_gateway

  def get_gateway_option_value
    gateway_option_value ? gateway_option_value.value : nil
  end

end
