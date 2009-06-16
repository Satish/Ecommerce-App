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

  cattr_reader :per_page
  @@per_page = 15

  TAX_RATE = 0.25
  ESTIMATED_SHIPPING_AMOUNT = 90.00

  named_scope :pending, :conditions => { :status => 'pending' }
  named_scope :approved, :conditions => { :status => 'approved' }
  named_scope :on_hold, :conditions => { :status => 'on_hold' }

  validates_presence_of :account_id, :billing_address_id, :shipping_address_id

  validates_associated :line_items

  has_many :line_items, :dependent => :destroy
  has_many :skus, :through => :line_items
  has_many :notes, :as => :noteable, :order => 'created_at DESC'
  has_one :billing_address, :as => :addressable, :dependent => :destroy
  has_one :shipping_addresses, :as => :addressable, :dependent => :destroy

  belongs_to :user

#  acts_as_state_machine :initial => :stocking, :column => 'status'
#  state :stocking
#  state :checking_out,
#    :enter => Proc.new{ |order| order.update_attribute(:billing_address, order.account.billing_address.to_s) }
#  state :pending,
#    :after => :deliver_mail
#  state :approved,
#    :after => :deliver_mail
#  state :on_hold
#  state :rejected
#  state :fulfilled
#
#  event :check_out do
#    transitions :from => :stocking, :to => :checking_out
#  end
#
#  event :stock do
#    transitions :from => :checking_out, :to => :stocking
#    transitions :from => :pending, :to => :stocking
#    transitions :from => :approved, :to => :stocking
#  end
#
#  event :order do
#    # Figure out a way to add a condition to the transition so that it uses the account credit logic
#    # and sets it to either pending or approved
#    transitions :from => :checking_out, :to => :pending
#    transitions :from => :stocking, :to => :pending
#  end
#
#  event :hold do
#    transitions :from => :pending, :to => :on_hold
#    transitions :from => :approved, :to => :on_hold
#    transitions :from => :rejected, :to => :on_hold
#    transitions :from => :fulfilled, :to => :on_hold
#  end
#
#  event :approve do
#    transitions :from => :pending, :to => :approved, :guard => :account_approved?
#    transitions :from => :rejected, :to => :approved, :guard => :account_approved?
#    transitions :from => :on_hold, :to => :approved, :guard => :account_approved?
#    transitions :from => :stocking, :to => :approved, :guard => :account_approved?
#    transitions :from => :checking_out, :to => :approved, :guard => :account_approved?
#    transitions :from => :fulfilled, :to => :approved, :guard => :account_approved?
#  end
#
#  event :reject do
#    transitions :from => :pending, :to => :rejected
#    transitions :from => :approved, :to => :rejected
#    transitions :from => :on_hold, :to => :rejected
#    transitions :from => :stocking, :to => :rejected
#    transitions :from => :checking_out, :to => :rejected
#    transitions :from => :fulfilled, :to => :rejected
#  end
#
#  event :fulfilled do
#    transitions :from => :approved, :to => :fulfilled
#  end

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

end
