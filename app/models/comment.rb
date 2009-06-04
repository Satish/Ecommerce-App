# == Schema Information
#
# Table name: comments
#
#  id               :integer(4)      not null, primary key
#  author           :string(255)
#  author_url       :string(255)
#  author_email     :string(255)
#  description      :text
#  spam             :boolean(1)
#  state            :string(15)      default("unapproved")
#  commentable_id   :integer(4)
#  commentable_type :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  deleted_at       :datetime
#

class Comment < ActiveRecord::Base

  @@per_page = PER_PAGE
  cattr_reader :per_page

  include Authentication
  include AASM

  attr_protected :state, :spam, :commentable_id, :commentable_type
  
  named_scope :approved, :conditions => { :state => 'approved', :spam => false }
  named_scope :unapproved, :conditions => { :state => 'approved' }
  
  validates_presence_of :author, :author_email, :description, :commentable_id, :commentable_type
  validates_uniqueness_of :description, :scope => [:author, :author_email, :commentable_id, :commentable_type]
  validates_format_of :author_email, :with => Authentication.email_regex, :message => Authentication.bad_email_message

  belongs_to :commentable, :polymorphic => true#, :counter_cache => true


  aasm_column :state
  aasm_initial_state :initial => :unapproved
  aasm_state :unapproved, :enter => :do_unapprove
  aasm_state :approved, :enter => :do_approve
  aasm_state :deleted, :enter => :do_delete

  aasm_event :approve do
    transitions :from => [:unapproved, :deleted], :to => :approved
  end

  aasm_event :unapprove do
    transitions :from => [:approved, :deleted], :to => :unapproved
  end

  aasm_event :delete do
    transitions :from => [:approved, :unapproved], :to => :deleted
  end

  def self.search(query, options)
    conditions = ["author like ? or author_email like ? or description like ?", "%#{query}%", "%#{query}%", "%#{query}%"] unless query.blank?
    default_options = {:conditions => conditions, :order => "created_at DESC, author"}
    
    paginate default_options.merge(options)
  end

  private ############################

  def do_delete
    self.deleted_at = Time.now.utc
  end

  def do_approve
    self.deleted_at = nil
  end

  def do_unapprove
    self.deleted_at = nil
  end

end
