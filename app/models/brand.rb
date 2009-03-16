# == Schema Information
#
# Table name: brands
#
#  id               :integer(4)      not null, primary key
#  name             :string(255)
#  permalink        :string(255)
#  meta_title       :string(255)
#  description      :text
#  meta_description :text
#  meta_keywords    :text
#  store_id         :integer(4)
#  status           :boolean(1)      default(TRUE)
#  deleted_at       :datetime
#  created_at       :datetime
#  updated_at       :datetime
#

class Brand < ActiveRecord::Base
  
  validates_presence_of :name, :permalink, :description, :store_id
  validates_uniqueness_of :name, :permalink, :scope => :store_id
  
  has_many :images, :dependent => :destroy
  has_many :products, :dependent => :destroy
  
  belongs_to :store

end
