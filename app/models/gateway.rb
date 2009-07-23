# == Schema Information
#
# Table name: gateways
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  description :text
#  state       :boolean(1)      default(TRUE)
#  created_at  :datetime
#  updated_at  :datetime
#

class Gateway < ActiveRecord::Base

  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :store_gateways

end
