# == Schema Information
#
# Table name: stores
#
#  id                       :integer(4)      not null, primary key
#  domain                   :string(255)
#  email                    :string(255)
#  address                  :string(255)
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
#  handling_fee             :decimal(8, 2)   default(0.0)
#

class Store < ActiveRecord::Base

  validates_presence_of :domain, :email, :display_name
  validates_uniqueness_of :domain

  has_many :categories, :dependent => :destroy, :include => :images
  has_many :products, :dependent => :destroy, :include => :images
  has_many :skus, :through => :products
  has_many :brands, :dependent => :destroy, :include => :images
  has_many :product_attributes, :dependent => :destroy
  has_many :images, :dependent => :destroy
  has_many :users, :dependent => :destroy
  has_many :pages, :dependent => :destroy
  has_many :roles, :dependent => :destroy
  has_many :orders, :dependent => :destroy
  has_many :currencies, :dependent => :destroy

  #has_many :store_countries, :dependent => :destroy
  has_many :countries#, :through => :store_countries
  
  has_many :shipping_methods, :dependent => :destroy
  has_many :shipping_countries, :through => :shipping_methods

  has_one :blog, :dependent => :destroy
  has_one :mail_setting, :dependent => :destroy

  after_create :create_blog, :create_admin, :create_store_countries
  before_create :build_pages


  def product_selection_option?(option)
    option == 'drop_down' # allow admin to choose the options
  end

  private ################################

  def create_blog
    blog = Blog.new(:email => email, :time_zone => "New Delhi", :feeds_description => FEEDS_DESCRIPTION_OPTIONS.first)
    blog.store = self
    blog.save!
  end

  def create_admin
    password = "changeme"
    user = User.new(:login => "login#{id}", :password => password, :password_confirmation => password, :email => email)
    self.users << user
    user.register!
    user.activate!
    user.roles << Role.find_by_name('admin')
  end

  def create_store_countries
    Country.create(ISO_COUNTRIES){ |c| c.store_id = id }
  end

  def build_pages
    ['About US', "Contact US", "FAQ", "Privacy Policy"].each do |title|
      self.pages.build(:title => title, :description => "#{ title} description")
    end
  end

end
