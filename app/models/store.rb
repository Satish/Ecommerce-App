# == Schema Information
#
# Table name: stores
#
#  id                       :integer(4)      not null, primary key
#  domain                   :string(255)
#  email                    :string(255)
#  address                  :string(255)
#  blog_title               :string(255)
#  display_name             :string(255)
#  toll_free_number         :string(255)
#  meta_title               :string(255)
#  google_analytics_account :string(255)
#  add_this_username        :string(255)
#  description              :text
#  disable_message          :text
#  meta_description         :text
#  meta_keywords            :text
#  status                   :boolean(1)      default(TRUE)
#  deleted_at               :datetime
#  created_at               :datetime
#  updated_at               :datetime
#

class Store < ActiveRecord::Base

  validates_presence_of :domain, :email, :display_name
  validates_uniqueness_of :domain

  has_many :categories, :dependent => :destroy, :include => :images
#  has_many :parent_categories, :group => :parent_id, :class_name => "Category"
  has_many :products, :dependent => :destroy, :include => :images
  has_many :skus, :through => :products
  has_many :brands, :dependent => :destroy, :include => :images
  has_many :product_attributes, :dependent => :destroy
  has_many :images, :dependent => :destroy
  has_many :users, :dependent => :destroy
  has_many :pages, :dependent => :destroy
  has_one :blog, :dependent => :destroy
  has_many :roles, :dependent => :destroy
  
  after_create :create_blog, :create_admin
  before_create :build_pages

  private ################################

  def create_blog
    blog = Blog.new(:email => email, :time_zone => "New Delhi", :feeds_description => FEEDS_DESCRIPTION_OPTIONS.first)
    blog.store = self
    blog.save!
  end

  def create_admin
    password = "changeme"
    user = User.new(:login => "login#{id}", :password => password, :password_confirmation => password, :email => email)
    role = Role.new(:name => 'admin')
    self.users << user
    user.activate!
    self.roles << role
    user.roles << roles
  end

  def build_pages
    ['About US', "Contact US", "FAQ", "Privacy Policy"].each do |title|
      self.pages.build(:title => title, :description => "#{ title} description")
    end
  end

end
