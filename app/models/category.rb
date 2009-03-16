# == Schema Information
#
# Table name: categories
#
#  id               :integer(4)      not null, primary key
#  title            :string(255)
#  permalink        :string(255)
#  meta_title       :string(255)
#  description      :text
#  meta_description :text
#  meta_keywords    :text
#  store_id         :integer(4)
#  parent_id        :integer(4)
#  status           :boolean(1)
#  deleted_at       :datetime
#  created_at       :datetime
#  updated_at       :datetime
#

class Category < ActiveRecord::Base
  
  validates_presence_of :title, :permalink, :description, :store_id
  validates_uniqueness_of :title, :permalink, :scope => :store_id
  
  has_many :images, :dependent => :destroy
  
  belongs_to :store

end
