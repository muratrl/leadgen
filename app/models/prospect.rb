class Prospect < ActiveRecord::Base
  self.table_name = 'prospect_user'
  # attr_accessible :owner_1_first_name, :owner_2_first_name, :owner_2_last_name,
  # :property_address, :property_city, :property_state,
  # :property_zip_code, :mail_address, :mail_city, :mail_state, :mail_zip_code

  def self.search(search)
    if search
      where('owner_1_first_name LIKE ? or owner_1_last_name LIKE ? or
      owner_2_first_name LIKE ? or owner_2_last_name LIKE ? or
      property_address LIKE ? or property_city LIKE ? or
      property_state LIKE ? or property_zip_code LIKE ? or
      mail_address LIKE ? or mail_city LIKE ? or
      mail_state LIKE ? or mail_zip_code LIKE ?',
      "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%",
      "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%",
      "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
    else
      all
    end
  end
end
