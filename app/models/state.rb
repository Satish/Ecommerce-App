# == Schema Information
#
# Table name: states
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  abbr       :string(2)
#  country_id :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

class State < ActiveRecord::Base

  @@per_page = PER_PAGE
  cattr_reader :per_page
  attr_protected :store_country_id, :country_id

  validates_presence_of   :name, :abbr, :store_country_id
  validates_uniqueness_of :name, :abbr

  belongs_to :country
  belongs_to :store_country

  def self.search(query, options)
    conditions = ["states.name like ? or states.abbr like ?", "%#{ query }%", "%#{ query }%"] unless query.blank?
    default_options = {:conditions => conditions, :order => "states.name" }

    paginate default_options.merge(options)
  end

end
