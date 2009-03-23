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
#  active           :boolean(1)      default(TRUE)
#  deleted_at       :datetime
#  created_at       :datetime
#  updated_at       :datetime
#

class Brand < ActiveRecord::Base
  
  @@per_page = 5
  cattr_reader :per_page
  
  has_permalink :name, :permalink
  attr_protected :store_id
  
  validates_presence_of :name, :permalink, :description, :store_id
  validates_uniqueness_of :name, :permalink, :scope => :store_id
  
  has_many :images, :dependent => :destroy, :as => :attachable
  has_many :products, :dependent => :destroy
  
  belongs_to :store
  
  def self.search(query, options)
    conditions = ["name like ? or description like ?", "%#{query}%", "%#{query}%"] unless query.blank?
    default_options = {:conditions => conditions, :order => "created_at DESC, name"}
    
    paginate default_options.merge(options)
  end
  
  def new_image_attributes=(image_attributes)
    image_attributes.each do |image|
      self.images.build(image)
    end
  end
  
end
