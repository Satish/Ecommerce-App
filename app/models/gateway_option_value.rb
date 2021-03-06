# == Schema Information
#
# Table name: gateway_option_values
#
#  id                :integer(4)      not null, primary key
#  value             :text
#  gateway_option_id :integer(4)
#  created_at        :datetime
#  updated_at        :datetime
#

class GatewayOptionValue < ActiveRecord::Base

  attr_protected :gateway_option_id

  validates_presence_of :value, :gateway_option_id
  validates_uniqueness_of :gateway_option_id

  belongs_to :gateway_option

end
