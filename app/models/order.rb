# == Schema Information
#
# Table name: orders
#
#  id                  :integer(4)      not null, primary key
#  user_id             :integer(4)
#  store_id            :integer(4)
#  shipping_address_id :integer(4)
#  billing_address_id  :integer(4)
#  status              :string(255)     default("pending")
#  tracking_number     :string(255)
#  payment_type        :string(255)
#  transaction_id      :integer(4)
#  order_id            :integer(4)
#  total_amount        :decimal(8, 2)   default(0.0)
#  tax_amount          :decimal(8, 2)   default(0.0)
#  shipping_amount     :decimal(8, 2)   default(0.0)
#  handling_amount     :decimal(8, 2)   default(0.0)
#  total_discount      :decimal(8, 2)   default(0.0)
#  deleted_at          :datetime
#  created_at          :datetime
#  updated_at          :datetime
#

class Order < ActiveRecord::Base

  include AASM

  cattr_reader :per_page
  @@per_page = 15

  named_scope :active, :conditions => { :deleted_at => nil }
  named_scope :pending, :conditions => { :status => 'pending' }
  named_scope :approved, :conditions => { :status => 'approved' }
  named_scope :on_hold, :conditions => { :status => 'on_hold' }

  attr_accessor :order_number, :card_number, :card_type, :card_expiration_month, :card_expiration, :card_expiration_year, :card_verification_value

  validates_associated :line_items, :billing_address, :shipping_address

  has_many :line_items, :dependent => :destroy
  has_many :skus, :through => :line_items
  has_many :notes, :as => :noteable, :order => 'created_at DESC'
  has_one :billing_address, :as => :addressable, :dependent => :destroy
  has_one :shipping_address, :as => :addressable, :dependent => :destroy
  belongs_to :user
  belongs_to :store

  before_create :generate_order_number, :calculate_total_amount

  aasm_column :status
  aasm_initial_state :initial => :pending
  aasm_state :pending, :enter => :do_pending
  aasm_state :processing, :enter => :do_process
  aasm_state :rejected, :enter => :do_reject
  aasm_state :fullfilled, :enter => :do_fullfill
  aasm_state :deleted, :enter => :do_delete

  aasm_event :process do
    transitions :from => [:pending, :on_hold, :rejected, :fullfilled], :to => :processing
  end

  aasm_event :hold do
    transitions :from => [:pending, :processing, :rejected, :fullfilled], :to => :on_hold
  end

  aasm_event :reject do
    transitions :from => [:pending, :on_hold, :processing, :fullfilled], :to => :rejected
  end

  aasm_event :fulfilled do
    transitions :from => :processing, :to => :fulfilled
  end

  aasm_event :delete do
    transitions :from => [:pending, :processing, :on_hold, :rejected, :fullfilled], :to => :deleted
  end

  #-------------------------- private ----------------------------------
  private

  def calculate_total_amount
    self.total_amount = total_amount_before_shipping + estimated_shipping_amount
  end

  def estimated_shipping_amount
    self.shipping_amount = total_amount_before_shipping == 0 ? 0 : 0
  end

  def total_amount_before_shipping
    amount = cost_of_products + calculate_tax_amount + calculate_handling_amount
    amount || 0
  end

  def calculate_tax_amount
    self.tax_amount = cost_of_products * 0 # should replace 0 with the tax rate
#    store.tax_options.active.each do |to|
#      self.tax_amount = self.total_amount * (to.tax_percent/100) and break if to.country == shipping_address.country and to.state == shipping_address.state
#    end
  end

  def cost_of_products
    line_items.collect(&:calculate_price).sum
  end

  def calculate_handling_amount
    self.handling_amount =  products_handling_fee + store.handling_fee
  end

  def products_handling_fee
    line_items.collect(&:calculate_handling_fee).sum
  end

  def generate_order_number
    self.number = generate_unique_number
  end

  def generate_unique_number
    begin
      new_number = "OR#{ Time.now.strftime("%Y%d%m") }#{ Array.new(15){rand(9)}.join }"
    end until !order_exists?(new_number)
    new_number
  end

  # Checks the database to ensure the specified number is not taken
  def order_exists?(new_number)
    Order.find :first, :conditions => { :number => new_number }
  end


  def do_pending
  
  end

  def do_process

  end

  def do_reject
    restock_inventory
    OrderMailer.rejected_order(self)
  end

  def do_fullfill

  end

  def do_delete

  end

  def restock_inventory
#    line_items.each do |line_item|
#      line_item.quantity
#    end
  end
end
