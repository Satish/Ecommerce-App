class Role < ActiveRecord::Base
  
  validates_presence_of :name
  validates_uniqueness_of :name
  
  has_many :roles_users, :dependent => :destroy, :conditions => {:active => true}
  has_many :users, :through => :roles_users
  
end