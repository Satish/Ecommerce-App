# == Schema Information
#
# Table name: addresses
#
#  id               :integer(4)      not null, primary key
#  type             :string(255)
#  first_name       :string(255)
#  last_name        :string(255)
#  street1          :string(255)
#  street2          :string(255)
#  city             :string(255)
#  state            :string(255)
#  zipcode          :string(255)
#  country          :string(255)
#  email            :string(255)
#  phone            :string(255)
#  fax              :string(255)
#  company          :string(255)
#  addressable_id   :integer(4)
#  addressable_type :string(255)
#  default          :boolean(1)
#  created_at       :datetime
#  updated_at       :datetime
#

class BillingAddress < Address
end
