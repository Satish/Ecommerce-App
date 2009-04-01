class Blog < ActiveRecord::Base
  
  include Authentication
  
  attr_protected :store_id
  
  validates_uniqueness_of :store_id
  validates_presence_of :posts_per_page, :feeds_description, :time_zone, :email, :store_id
  validates_format_of :email, :with => Authentication.email_regex, :message => Authentication.bad_email_message
  validates_inclusion_of :feeds_description, :in => FEEDS_DESCRIPTION_OPTIONS, :message => "{{value}} is not included in the list"
  validates_numericality_of :posts_per_page, :greater_than_or_equal_to => 1
  validates_length_of :title, :maximum => 50, :message=>"less than {{count}} if you don't mind", :if => Proc.new{|b| b.title.length > 0}
  validates_length_of :sub_title, :maximum => 50, :message=>"less than {{count}} if you don't mind", :if => Proc.new{ |b| b.sub_title }
  
  has_many :posts, :dependent => :destroy
  belongs_to :store
  
end
