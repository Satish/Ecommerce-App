class Comment < ActiveRecord::Base
  
  include Authentication
  
  attr_protected :state, :spam, :commentable_id, :commentable_type
  
  named_scope :approved, :conditions => { :state => 'approved', :spam => false }
  named_scope :unapproved, :conditions => { :state => 'approved' }
  
  validates_presence_of :author, :author_email, :description, :commentable_id, :commentable_type
  validates_uniqueness_of :description, :scope => [:author, :author_email, :commentable_id, :commentable_type]
  validates_format_of :author_email, :with => Authentication.email_regex, :message => Authentication.bad_email_message

  belongs_to :commentable, :polymorphic => true
  
  acts_as_state_machine :initial => :unapproved, :column => 'state'
  
  state :unapproved
  state :approved
  state :deleted

  event :approve do
    transitions :from => :unapproved, :to => :approved
  end

  event :unapprove do
    transitions :from => :unapprove, :to => :approve
  end

  event :delete do
    transitions :from => :approve, :to => :deleted
    transitions :from => :unapprove, :to => :deleted
  end
  
  def self.search(query, options)
    conditions = ["author like ? or author_email like ? or description like ?", "%#{query}%", "%#{query}%", "%#{query}%"] unless query.blank?
    default_options = {:conditions => conditions, :order => "created_at DESC, author"}
    
    paginate default_options.merge(options)
  end
  
end
