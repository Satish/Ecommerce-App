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
#  active                   :boolean(1)      default(TRUE)
#  handling_fee             :float           default(0.0)
#  deleted_at               :datetime
#  created_at               :datetime
#  updated_at               :datetime
#

class Store < ActiveRecord::Base

  default_scope :order => "stores.created_at, stores.domain"

  validates_presence_of :domain, :email, :display_name
  validates_uniqueness_of :domain

  has_many :categories, :dependent => :destroy, :include => [:images, :children]
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

  has_many :store_gateways, :dependent => :destroy
  has_many :gateways, :through => :store_gateways

  has_many :store_countries, :dependent => :destroy, :include => [:country]
  has_many :countries, :through => :store_countries

  has_many :shipping_methods, :dependent => :destroy
  has_many :shipping_countries, :through => :shipping_methods

  has_one :blog, :dependent => :destroy
  has_one :mail_setting, :dependent => :destroy
  has_one :logo, :dependent => :destroy, :as => :attachable
  has_one :favicon_icon, :dependent => :destroy, :as => :attachable

  after_create :create_blog, :create_admin, :create_store_countries, :create_mail_setting, :create_gateways, :activate_first_gateway
  before_create :build_pages


  def product_selection_option?(option)
    option == 'drop_down' # allow admin to choose the options
  end

  def store_gateway
    @store_gateway ||= store_gateways.active.first
  end

  def logo_attributes=logo_attributes
    unless logo
      self.logo = Logo.new(:uploaded_data => logo_attributes)
    else
      self.logo.update_attributes(:uploaded_data => logo_attributes)
    end
  end

  def favicon_icon_attributes=favicon_icon_attributes
    unless favicon_icon
      self.favicon_icon = FaviconIcon.new(:uploaded_data => favicon_icon_attributes)
    else
      self.favicon_icon.update_attributes(:uploaded_data => favicon_icon_attributes)
    end
  end

  def self.search(query, options)
    default_conditions = query.blank? ? '' : "domain like '%#{ query }%' or display_name like '%#{ query }%' or email like '%#{ query }%'"

    default_conditions << ' and ' if options[:conditions] and !default_conditions.blank?
    default_conditions << options.delete(:conditions) if options[:conditions]

    default_options = {:conditions => default_conditions, :include => [:logo] }
    paginate default_options.merge(options)
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
    self.countries << Country.all
  end

  def build_pages
    ['About US', "Contact US", "FAQ", "Privacy Policy"].each do |title|
      self.pages.build(:title => title, :description => "#{ title } description")
    end
  end

  def create_mail_setting
    mail_setting = MailSetting.new
    mail_setting.store = self
    mail_setting.save!
  end

  def create_gateways
    self.gateways << Gateway.all
     store_gateways.each do |sg|
      sg.gateway_options << GatewayOption.create(GATEWAY_OPTIONS[sg.gateway.name])
    end
  end

  def activate_first_gateway
    store_gateways.first.reload.activate!
  end

end
