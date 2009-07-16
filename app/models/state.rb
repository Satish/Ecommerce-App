# == Schema Information
#
# Table name: states
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  abbr       :string(2)
#  country_id :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class State < ActiveRecord::Base

  validates_presence_of   :name, :abbr, :country_id
  validates_uniqueness_of :name, :abbr

  belongs_to :country

end
