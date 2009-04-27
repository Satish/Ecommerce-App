# == Schema Information
#
# Table name: posts
#
#  id               :integer(4)      not null, primary key
#  title            :string(255)
#  permalink        :string(255)
#  cached_tag_list  :string(255)
#  description      :text
#  user_id          :integer(4)
#  blog_id          :integer(4)
#  active           :boolean(1)      default(TRUE)
#  comments_allowed :boolean(1)      default(TRUE)
#  state            :string(255)     default("draft")
#  published_at     :datetime
#  deleted_at       :datetime
#  created_at       :datetime
#  updated_at       :datetime
#

class Post < ActiveRecord::Base

  @@per_page = PER_PAGE
  cattr_reader :per_page

  include AASM
  acts_as_taggable
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

  aasm_column :state
  aasm_initial_state :initial => :draft
  aasm_state :draft, :enter => :do_draft
  aasm_state :published, :enter => :do_publish
  aasm_state :deleted, :enter => :do_delete

  aasm_event :conceal do
    transitions :from => [:published, :deleted], :to => :draft
  end

  aasm_event :publish do
    transitions :from => [:draft, :deleted], :to => :published
  end

  aasm_event :delete do
    transitions :from => [:draft, :published], :to => :deleted
  end
  
  def before_save
    self.published_at = (published? ? Time.now.utc : nil)
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

  private ############################

  def do_delete
    self.deleted_at = Time.now.utc
    self.published_at = nil
  end

  def do_publish
    self.published_at = Time.now.utc
    self.deleted_at = nil
  end

  def do_draft
    self.published_at = self.deleted_at = nil
  end

end
