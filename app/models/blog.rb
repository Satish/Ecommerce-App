# == Schema Information
#
# Table name: blogs
#
#  id                 :integer(4)      not null, primary key
#  title              :string(50)      default("My Blog")
#  sub_title          :string(50)      default("")
#  feeds_description  :string(20)
#  store_id           :integer(4)
#  email              :string(255)
#  time_zone          :string(255)
#  akismet_key        :string(255)
#  akismet_url        :string(255)
#  language           :string(255)
#  meta_title         :string(255)
#  description        :text
#  meta_description   :text
#  meta_keywords      :text
#  disable_message    :text
#  comment_moderation :boolean(1)      default(TRUE)
#  active             :boolean(1)      default(TRUE)
#  posts_per_page     :integer(4)      default(5)
#  created_at         :datetime
#  updated_at         :datetime
#

class Blog < ActiveRecord::Base

  @@per_page = PER_PAGE
  cattr_reader :per_page

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
