class Page < ActiveRecord::Base
  
  has_permalink :title, :permalink
  
  attr_protected :status, :active
  
  named_scope :active, :conditions => { :active => true }
  named_scope :inactive, :conditions => { :active=> false }
  
  validates_presence_of :title, :permalink, :description
  validates_uniqueness_of :title, :permalink
  
  
  def self.search(search, page)
    paginate :per_page => 5, :page => page,
             :conditions => ['title like ? or description like ?', "%#{search}%", "%#{search}%"], :order => 'title'
  end
  
end
