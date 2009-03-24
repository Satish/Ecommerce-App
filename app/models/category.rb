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
#  active           :boolean(1)      default(TRUE)
#  deleted_at       :datetime
#  created_at       :datetime
#  updated_at       :datetime
#

class Category < ActiveRecord::Base
  
  @@per_page = 5
  cattr_reader :per_page
  
  acts_as_tree
  has_permalink :title, :permalink
  attr_protected :store_id
  
  named_scope :parent_categories, :conditions => { :parent_id => nil }
  validates_presence_of :title, :permalink, :description, :store_id
  validates_uniqueness_of :title, :permalink, :scope => :store_id
  
  has_many :images, :dependent => :destroy, :as => :attachable
  has_many :categories_products, :dependent => :destroy
  has_many :products, :through => :categories_products#, :conditions => {:active => true}
  belongs_to :store
  
  def before_validation
    self.images.build if images.size < 1
  end
  
  def self.search(query, options)
    conditions = ["title like ? or description like ?", "%#{query}%", "%#{query}%"] unless query.blank?
    default_options = {:conditions => conditions, :order => "created_at DESC, title"}
    
    paginate default_options.merge(options)
  end
    
  def category_options_for_optgroup
    children
  end
  
  def new_image_attributes=(image_attributes)
    image_attributes.each do |image|
      self.images.build(image)
    end
  end
  
end
