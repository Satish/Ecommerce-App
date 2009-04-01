class Post < ActiveRecord::Base
  
  #acts_as_taggable
  acts_as_paranoid
  
  has_permalink :title, :permalink
  attr_protected :status, :active, :blog_id, :user_id
  
  named_scope :active, :conditions => { :active => true }
  named_scope :inactive, :conditions => { :active=> false }
  named_scope :published, :conditions => ['published_at IS NOT ? and published_at < ?', nil, Time.now.utc]
  
  validates_presence_of :title, :permalink, :description, :user_id, :blog_id
  validates_uniqueness_of :title, :permalink
  
  has_many :comments,  :as => :commentable, :dependent => :destroy
  
  belongs_to :owner, :class_name => "User", :foreign_key => "user_id"
  belongs_to :blog
  
  acts_as_state_machine :initial => :draft, :column => 'state'
  
  state :draft
  state :published
  state :deleted

  event :conceal do
    transitions :from => :published, :to => :draft
  end

  event :publish do
    transitions :from => :draft, :to => :published
  end

  event :delete do
    transitions :from => :draft, :to => :deleted
    transitions :from => :published, :to => :deleted
  end
  
  def before_save
    self.published_at = (published? ? Time.now.utc : nil)
  end
  
  def self.search(search, options)
    default_options = {:per_page => 5, :conditions => ['title like ? or description like ?', "%#{search}%", "%#{search}%"], :order => 'created_at DESC, title'}
    
    paginate default_options.merge(options)
  end
  
  def self.search(query, options)
    conditions = ["title like ? or description like ?", "%#{query}%", "%#{query}%"] unless query.blank?
    default_options = {:conditions => conditions, :order => "created_at DESC, title"}
    
    paginate default_options.merge(options)
  end
  
  def new_or_existing_tags
    tags.collect(&:name).join(",")
  end
  
  def new_or_existing_tags=(noe_tags)
    noe_tags.split(',').each do |tag_name|
      tags.build(:name => tag_name)
    end
  end
  
  def url
    created_at.strftime("/%Y/%m/%d/") + permalink
  end
  
  class << self
    def find_by_date_and_permalink(year, month, day, permalink, options={})
      begin
        post = Post.find_by_permalink(permalink, options)
        post && post.created_at.to_date == Date.new(year.to_i, month.to_i, day.to_i) ? post : nil
      rescue # Invalid time
        nil
      end
    end
    
  end
  
end
