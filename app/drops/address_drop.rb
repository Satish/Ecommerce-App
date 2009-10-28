class AddressDrop < BaseDrop

  liquid_attributes << :first_name << :last_name << :full_name << :street1 << :street2 << :city << :state << :zipcode << :country << :email
  liquid_attributes << :email << :phone << :fax << :company << :to_s

end