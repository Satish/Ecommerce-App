# == Schema Information
#
# Table name: users
#
#  id                        :integer(4)      not null, primary key
#  login                     :string(40)
#  crypted_password          :string(40)
#  salt                      :string(40)
#  remember_token            :string(40)
#  activation_code           :string(40)
#  name                      :string(100)     default("")
#  email                     :string(100)
#  activated_at              :datetime
#  remember_token_expires_at :datetime
#  deleted_at                :datetime
#  state                     :string(255)     default("passive")
#  created_at                :datetime
#  updated_at                :datetime
#  store_id                  :integer(4)
#

require 'digest/sha1'

class User < ActiveRecord::Base
  
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  include Authorization::StatefulRoles
  
  validates_presence_of     :login, :store_id
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message
  
  has_many :roles_users, :dependent => :destroy, :conditions => {:active => true}
  has_many :roles, :through => :roles_users
  
  belongs_to :store

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation



  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_in_state :first, :active, :conditions => {:login => login.downcase} # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  def self.search(search, page)
    paginate :per_page => 5, :page => page,
             :conditions => ['name like ? or email like ?', "%#{search}%", "%#{search}%"], :order => 'name'
  end
  
  # ---------------------------------------
  # has_role? simply needs to return true or false whether a user has a role or not.  
  # It may be a good idea to have "admin" roles return true always
  def has_role?(role_in_question)
    @_list ||= self.roles.collect(&:name)
    return true if @_list.include?("admin")
    (@_list.include?(role_in_question.to_s) )
  end
  # ---------------------------------------
  
  protected #############################
    
  def make_activation_code
    self.deleted_at = nil
    self.activation_code = self.class.make_token
  end

end
