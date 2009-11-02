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
#  active           :boolean(1)
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

  delegate :name, :to => :brand, :prefix => true

  default_scope :conditions => { :deleted_at => nil }
  validates_presence_of :name, :permalink, :description, :brand_id, :store_id, :price, :product_id
  validates_uniqueness_of :name, :permalink, :product_id, :scope => :store_id
  
  has_many :images, :dependent => :destroy, :as => :attachable
  has_many :skus, :dependent => :destroy
  has_many :attribute_values, :through => :skus

  has_many :categories_products, :dependent => :destroy
  has_many :categories, :through => :categories_products

  belongs_to :store
  belongs_to :brand
  
  def before_validation
    if product_id.blank?
      pid = Product.last(:select => "id").id rescue 0
      self.product_id = "PID#{ pid + 1 }"
    end
#    self.images.build if images.size < 1
  end
    
  def main_image
    images.first
  end
  
  def self.search(query, options)
    default_conditions = query.blank? ? '' : "name like '%#{ query }%' or description like '%#{ query }%'"

    default_conditions << ' and ' if options[:conditions] and !default_conditions.blank?
    default_conditions << options.delete(:conditions) if options[:conditions]

    default_options = {:conditions => default_conditions, :order => "products.created_at DESC, products.name", :include => [:skus] }
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

  def original_price
    price
  end

  alias :original_destroy :destroy

  def destroy
    self.update_attribute(:deleted_at, Time.zone.now)
  end

end
