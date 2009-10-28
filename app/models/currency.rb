# == Schema Information
#
# Table name: currencies
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  country    :string(255)
#  format     :string(255)
#  symbol     :string(10)
#  delimiter  :string(255)     default("."), not null
#  separator  :string(255)     default(","), not null
#  rate       :decimal(10, 8)
#  precision  :integer(4)      default(2), not null
#  store_id   :integer(4)
#  state      :string(10)      default("inactive")
#  created_at :datetime
#  updated_at :datetime
#

class Currency < ActiveRecord::Base

  include AASM

  cattr_reader :per_page
  @@per_page = PER_PAGE

  named_scope :active, :conditions => { :state => 'active' }
  named_scope :inactive, :conditions => { :state => 'inactive' }

  validates_presence_of :name,:symbol, :store_id
  validates_uniqueness_of :name, :symbol, :scope => :store_id

  belongs_to :store

  after_save :do_after_save

  aasm_column :state
  aasm_initial_state :initial => :inactive
  aasm_state :active, :enter => :do_after_save
  aasm_state :inactive

  aasm_event :activate do
    transitions :from => [:inactive], :to => :active
  end

  aasm_event :deactivate do
    transitions :from => [:active], :to => :inactive
  end

  def self.search(query, options)
    conditions = ["name like ? or symbol like ? or country like ?", "%#{ query }%", "%#{ query }%", "%#{ query }%"] unless query.blank?
    default_options = {:conditions => conditions, :order => "created_at DESC, name"}
    
    paginate default_options.merge(options)
  end

  private
  
  def do_after_save
    store.currencies.active.all(:conditions => ["currencies.id != ?", id]).each{ |c| c.deactivate! } if active?
  end

end
