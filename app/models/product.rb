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
#  active           :boolean(1)      default(TRUE)
#  dependent        :boolean(1)
#  deleted_at       :datetime
#  created_at       :datetime
#  updated_at       :datetime
#

class Product < ActiveRecord::Base
  
  TO_XML_OPTIONS = {:camelize => true, :methods => [:brand_name], :except => [:id, :active, :meta_title, :meta_description, :meta_keywords, :store_id, :brand_id, :deleted_at, :created_at, :updated_at]}

  @@per_page = PER_PAGE
  cattr_reader :per_page
  
  has_permalink :name, :permalink
  attr_protected :store_id
  
  validates_presence_of :name, :permalink, :description, :brand_id, :store_id, :price, :product_id
  validates_uniqueness_of :name, :permalink, :product_id, :scope => :store_id
  
  has_many :images, :dependent => :destroy, :as => :attachable
  has_many :skus, :dependent => :destroy
  
  belongs_to :store
  belongs_to :brand
  
  def before_validation
    if product_id.blank?
      pid = Product.last(:select => "id").id rescue 0
      self.product_id = "PID#{ pid + 1 }"
    end
    self.images.build if images.size < 1
  end
    
  def main_image
    images.first
  end
  
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
  
  def our_price
    price - discount
  end
  
  def percent_discount
    100 * discount/price
  end

  def brand_name
    brand.name
  end

  def original_price
    price
  end

end
