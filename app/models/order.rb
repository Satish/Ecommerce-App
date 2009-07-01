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

  TAX_RATE = 0.25
  ESTIMATED_SHIPPING_AMOUNT = 90.00

  named_scope :pending, :conditions => { :status => 'pending' }
  named_scope :approved, :conditions => { :status => 'approved' }
  named_scope :on_hold, :conditions => { :status => 'on_hold' }

  validates_presence_of :account_id, :billing_address_id, :shipping_address_id

  validates_associated :line_items
  attr_accessor :order_number, :card_number, :card_type, :card_expiration_month, :card_expiration, :card_expiration_year, :card_verification_value

  has_many :line_items, :dependent => :destroy
  has_many :skus, :through => :line_items
  has_many :notes, :as => :noteable, :order => 'created_at DESC'
  has_one :billing_address, :as => :addressable, :dependent => :destroy
  has_one :shipping_address, :as => :addressable, :dependent => :destroy

  belongs_to :user

  aasm_column :state
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

#  def self.unfulfilled
#    Order.find(:all, :conditions => "status = 'approved'")
#  end
#
#  def estimated_shipping_amount
#  # It looks stupid when the cart is empty but estimated shipping is being charged...
#    total_amount_before_shipping == 0 ? 0 : ESTIMATED_SHIPPING_AMOUNT
#  end
#
#  def total_amount_before_shipping
#    total_amount = cost_of_products + tax_amount
#    total_amount || 0
#  end
#
#  def total_amount
#    total_amount_before_shipping + estimated_shipping_amount
#  end
#
#  def tax_amount(cost_of_shipped_products = nil)
#    (cost_of_shipped_products||cost_of_products) * TAX_RATE
#  end
#
#  def cost_of_products
#    line_items.inject(0) do |sum, li| 
#      sum += li.calculate_price if li.sku && li.quantity
#    end
#  end

  #-------------------------- private ----------------------------------
  private

  def do_pending
  
  end

  def do_process

  end

  def do_reject

  end

  def do_fullfill

  end

  def do_delete

  end

end
