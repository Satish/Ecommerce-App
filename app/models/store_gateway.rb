# == Schema Information
#
# Table name: store_gateways
#
#  id         :integer(4)      not null, primary key
#  store_id   :integer(4)
#  gateway_id :integer(4)
#  state      :boolean(1)
#  created_at :datetime
#  updated_at :datetime
#

class StoreGateway < ActiveRecord::Base

  cattr_reader :per_page
  @@per_page = PER_PAGE

  attr_protected :gateway_id, :gateway_id

  named_scope :active, :conditions => { :state => true }
  named_scope :inactive, :conditions => { :state => false }

  validates_presence_of :store_id, :gateway_id
  validates_uniqueness_of :gateway_id, :scope => :store_id

  has_many :gateway_options
  belongs_to :store
  belongs_to :gateway


  def self.search(query, options)
    conditions = ["gateways.name like ? or gateways.description like ?", "%#{ query }%", "%#{ query }%"] unless query.blank?
    default_options = { :conditions => conditions, :order => "store_gateways.created_at DESC, gateways.name", :include => [:gateway] }

    paginate default_options.merge(options)
  end

  after_update :save_gateway_options

  def existing_gateway_option_attributes=gateway_option_attributes
     gateway_options.reject(&:new_record?).each do |gateway_option|
      attributes = gateway_option_attributes[gateway_option.id.to_s]
      if attributes
        unless gateway_option.gateway_option_value
          gateway_option.gateway_option_value = GatewayOptionValue.create(:value => attributes[:gateway_option_value])
        else
          gateway_option.gateway_option_value.update_attribute(:value, attributes[:gateway_option_value])
        end
      end
    end
  end

  def save_gateway_options
    gateway_options.each do |gateway_option|
      gateway_option.save(false)
    end
  end

end
