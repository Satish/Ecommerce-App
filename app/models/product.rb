# == Schema Information
#
# Table name: products
#
#  id               :integer(4)      not null, primary key
#  product_id       :string(255)
#  name             :string(255)
#  permalink        :string(255)
#  material         :string(255)
#  availability     :string(255)
#  ships_in         :string(255)
#  meta_title       :string(255)
#  description      :text
#  care_instruction :text
#  meta_description :text
#  meta_keywords    :text
#  brand_id         :integer(4)
#  store_id         :integer(4)
#  price            :float           default(0.0)
#  discount         :float           default(0.0)
#  handling_fee     :float           default(0.0)
#  status           :boolean(1)
#  dependent        :boolean(1)
#  deleted_at       :datetime
#  created_at       :datetime
#  updated_at       :datetime
#

class Product < ActiveRecord::Base
  
  validates_presence_of :name, :permalink, :description, :brand_id, :store_id, :price
  validates_uniqueness_of :name, :permalink, :product_id, :scope => :store_id
  
  has_many :images, :dependent => :destroy
  has_many :sku, :dependent => :destroy
  
  belongs_to :store

end
