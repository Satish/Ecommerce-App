# == Schema Information
#
# Table name: orders
#
#  id              :integer(4)      not null, primary key
#  user_id         :integer(4)
#  store_id        :integer(4)
#  status          :string(255)     default("pending")
#  tracking_number :string(255)
#  payment_type    :string(255)
#  transaction_id  :integer(4)
#  number          :string(255)
#  total_amount    :decimal(8, 2)   default(0.0)
#  tax_amount      :decimal(8, 2)   default(0.0)
#  shipping_amount :decimal(8, 2)   default(0.0)
#  handling_amount :decimal(8, 2)   default(0.0)
#  total_discount  :decimal(8, 2)   default(0.0)
#  deleted_at      :datetime
#  created_at      :datetime
#  updated_at      :datetime
#

class Order < ActiveRecord::Base

  include AASM

  cattr_reader :per_page
  @@per_page = 15

  named_scope :active, :conditions => { :deleted_at => nil }
  named_scope :pending, :conditions => { :status => 'pending' }
  named_scope :approved, :conditions => { :status => 'approved' }
  named_scope :on_hold, :conditions => { :status => 'on_hold' }

  attr_accessor :shipping_method_id, :first_name, :last_name, :card_number, :card_type, :card_verification_value, :card_expiration_year, :card_expiration_month#, :card_expiration_day

  validates_presence_of :shipping_method_id

  validates_presence_of :first_name, :last_name, :card_number, :card_type, :card_expiration_year, :card_expiration_month, :card_verification_value, :if => :creditcard?

  validates_inclusion_of :card_type,              :in => CARD_TYPES.values, :if => :creditcard_and_not_blank?
  validates_inclusion_of :card_expiration_month,  :in => (1..12).to_a
  validates_inclusion_of :card_expiration_year,   :in => VALID_EXPIRY_YEARS

  validates_associated :line_items#, :billing_address, :shipping_address

  has_many :line_items, :dependent => :destroy
  has_many :skus, :through => :line_items
  has_many :shipments, :dependent => :destroy
  has_many :creditcards, :dependent => :destroy

  has_many :notes, :as => :noteable, :order => 'created_at DESC'

  has_one :billing_address, :as => :addressable, :dependent => :destroy
  has_one :shipping_address, :as => :addressable, :dependent => :destroy

  belongs_to :user
  belongs_to :store

  before_validation :do_before_validation, :verify_card_information
  before_validation_on_create :validate_shipping_method
  before_create :calculate_total_amount, :process_order, :generate_order_number
  after_save :create_shipment, :create_creditcard

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

  def capture(cc_txn)
    @response = gateway.capture(cc_txn.amount * 100, cc_txn.transaction_id, relevant_customer_info)
    if @response.success?
      @response.params['transaction_id'] = 0 if gateway.is_a?(ActiveMerchant::Billing::BogusGateway)
      cc_txn.creditcard.creditcard_transactions.create(
        :transaction_id => @response.params['transaction_id'],
        :action         => 'captured',
        :amount         => tcc_txn.amount,
        :response_code  => @response.authorization
      )
    else
      self.errors.add_to_base("Unable to capture the amount because #{ @response.message }") and return false
    end
  end

  #-------------------------- private ----------------------------------
  private

  def do_before_validation
    self.card_expiration_year = card_expiration_year.to_i unless card_expiration_year.blank?
    self.card_expiration_month = card_expiration_month.to_i unless card_expiration_month.blank?
    self.shipping_method_id = shipping_method_id.to_i unless shipping_method_id.blank?
  end

  def validate_shipping_method
    unless shipping_method_id.blank?
      @shipping_method = store.shipping_methods.active.find_by_id(shipping_method_id)
      self.errors.add(:shipping_method_id, "is invalid") and return false unless @shipping_method
    end
  end

  def verify_card_information
    self.errors.add_to_base('Card information could not be validated') and return false unless credit_card.valid?
  end

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

  #generate order number OR[year][date][month][random number] ie 'OR[2009][28][07][180163448538246]'
  def generate_order_number
    self.number = generate_unique_number
  end

  # real stuff to generate uniq order number
  def generate_unique_number
    begin
      new_number = "OR#{ Time.now.strftime("%Y%d%m") }#{ Array.new(15){ rand(9) }.join }"
    end until !order_exists?(new_number)
    new_number
  end

  # Checks the database to ensure the specified number is not taken
  def order_exists?(new_number)
    Order.find :first, :conditions => { :number => new_number }
  end

  #active merchant credit card
  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
      :first_name => first_name,
      :last_name  => last_name,
      :type       => card_type,
      :number     => card_number,
      :month      => card_expiration_month,
      :year       => card_expiration_year,
      :verification_value  => card_verification_value
    )
  end

  #authorize/capture payment
  def process_order
    amount = total_amount * 100   # convert to cents
    credit_card.number = '1' and credit_card.type = 'bogus' if gateway.is_a?(ActiveMerchant::Billing::BogusGateway)

    @response = gateway.authorize(amount, credit_card, relevant_customer_info)
    if @response.success?
      @response.params['transaction_id'] = 0 if gateway.is_a?(ActiveMerchant::Billing::BogusGateway)
    else
      self.errors.add_to_base("Card information could not be validated because #{ @response.message }") and return false
    end
  end

  def gateway
    store_gateway = store.store_gateway
    @gateway ||= case store_gateway.gateway.name
    when 'Paypal - Website Payments Pro'

    when 'Authorize.net'
      ActiveMerchant::Billing::AuthorizeNetGateway.new(
        :login    => store_gateway.gateway_options.find_by_name('login').get_gateway_option_value,
        :password => store_gateway.gateway_options.find_by_name('password').get_gateway_option_value,
        :test     => (store_gateway.gateway_options.find_by_name('test').get_gateway_option_value == 'true') ? true : false
      )
    else
      ActiveMerchant::Billing::BogusGateway.new
    end
  end

  def relevant_customer_info
    { :billing_address  => generate_address_hash(billing_address),
      :shipping_address => generate_address_hash(shipping_address),
      :order_id         => number,
      :customer         => billing_address.email, 
      :email            => shipping_address.email,
#     :ip               => ip_address,
#     :shipping         => shipping_amount * 100,
#     :tax              => tax_amount * 100,
#     :subtotal         => item_total * 100
    }
  end

  # Generates an ActiveMerchant compatible address hash from address objects
  def generate_address_hash(address)
    return {} if address.nil?
    { :name     => address.full_name,
      :address1 => address.street1,
      :address2 => address.street2,
      :city     => address.city,
      :state    => address.state,
      :zip      => address.zipcode,
      :country  => address.country,
      :phone    => address.phone }
  end

  # first (default) shipment for the order
  def create_shipment
    self.shipments << Shipment.new(:shipping_method_id => @shipping_method, :shipping_address_id => shipping_address.id ) if shipments.empty?
  end

  def create_creditcard
    self.creditcards <<  @creditcard = Creditcard.new(
      :number                   => card_number,
      :display_number           => credit_card.display_number,
      :cc_type                  => card_type,
      :first_name               => first_name,
      :last_name                => last_name,
      :month                    => card_expiration_month,
      :year                     => card_expiration_year,
      :verification_value       => card_verification_value
     )
    @creditcard.creditcard_transactions.create(
      :transaction_id => @response.params['transaction_id'],
      :action         => 'authorized',
      :amount         => total_amount,
      :response_code  => @response.authorization
    )
  end

  def do_pending;  end

  def do_process; end

  def do_reject
    restock_inventory
    OrderMailer.rejected_order(self)
  end

  def do_fullfill; end

  def do_delete; end

  def restock_inventory; end

  def creditcard?
    payment_type == 'creditcard'
  end

  def creditcard_and_not_blank?
    !card_type.blank? && creditcard?
  end

end
