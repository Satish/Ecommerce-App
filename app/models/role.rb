# == Schema Information
#
# Table name: roles
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  store_id   :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class Role < ActiveRecord::Base

  @@per_page = PER_PAGE
  cattr_reader :per_page

  attr_accessible :name

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :store_id
  
  has_many :roles_users, :dependent => :destroy
  has_many :users, :through => :roles_users
  belongs_to :store
  
end
