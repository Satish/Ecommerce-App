# == Schema Information
#
# Table name: pages
#
#  id          :integer(4)      not null, primary key
#  title       :string(255)
#  permalink   :string(255)
#  store_id    :integer(4)
#  description :text
#  active      :boolean(1)      default(TRUE)
#  created_at  :datetime
#  updated_at  :datetime
#

class Page < ActiveRecord::Base
  
  @@per_page = PER_PAGE
  cattr_reader :per_page
  
  has_permalink :title, :permalink
  attr_protected :store_id
  
  named_scope :active, :conditions => { :active => true }
  named_scope :inactive, :conditions => { :active=> false }
  
  validates_presence_of :title, :permalink, :description
  validates_uniqueness_of :title, :permalink, :scope => :store_id
    
  def self.search(query, options)
    conditions = ["title like ? or description like ?", "%#{query}%", "%#{query}%"] unless query.blank?
    default_options = {:conditions => conditions, :order => "created_at DESC, title"}
    
    paginate default_options.merge(options)
  end

end
