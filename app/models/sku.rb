# == Schema Information
#
# Table name: skus
#
#  id               :integer(4)      not null, primary key
#  number           :string(255)
#  quantity         :integer(4)      default(0)
#  additional_price :float           default(0.0)
#  product_id       :integer(4)
#  deleted_at       :datetime
#  active           :boolean(1)      default(TRUE)
#  created_at       :datetime
#  updated_at       :datetime
#

class Sku < ActiveRecord::Base
  
  validates_presence_of :number, :quantity, :additional_price, :product_id
  validates_uniqueness_of :number, :scope => :product_id
  
  has_many :attribute_values, :dependent => :destroy
  
  belongs_to :product

  def before_validation
    self.number = rand(5)
  end
  
  def after_create
    update_attribute(:number, "SKU#{id + 251}")
  end
  
  def self.search(query, options)
    conditions = ["number like ?", "%#{query}%"] unless query.blank?
    default_options = {:conditions => conditions, :order => "created_at DESC, number"}
    
    paginate default_options.merge(options)
  end


end
