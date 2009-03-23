# == Schema Information
#
# Table name: roles_users
#
#  id         :integer(4)      not null, primary key
#  role_id    :integer(4)
#  user_id    :integer(4)
#  active     :boolean(1)      default(TRUE)
#  created_at :datetime
#  updated_at :datetime
#

class RolesUser < ActiveRecord::Base
  
  belongs_to :role
  belongs_to :user
  
end
