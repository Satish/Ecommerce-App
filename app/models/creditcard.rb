# == Schema Information
#
# Table name: creditcards
#
#  id                 :integer(4)      not null, primary key
#  first_name         :string(255)
#  last_name          :string(255)
#  cc_type            :string(255)
#  month              :string(255)
#  year               :string(255)
#  number             :string(255)
#  verification_value :string(255)
#  display_number     :string(255)
#  order_id           :integer(4)
#  created_at         :datetime
#  updated_at         :datetime
#

class Creditcard < ActiveRecord::Base
  
  validates_presence_of :first_name, :last_name, :cc_type, :month, :year, :number, :verification_value, :order_id

  has_many :creditcard_transactions, :dependent => :destroy
  belongs_to :order

end
