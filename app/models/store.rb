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

  has_many :categories, :dependent => :destroy#, :conditions => {:parent_id => nil}
  has_many :products, :dependent => :destroy
  has_many :brands, :dependent => :destroy
  has_many :product_attributes, :dependent => :destroy
  has_many :images, :dependent => :destroy
  has_many  :users, :dependent => :destroy
  has_many  :pages, :dependent => :destroy
 
end
