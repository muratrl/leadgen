class Prospect < ActiveRecord::Base
  self.table_name = 'prospect_user'
  # attr_accessible :owner_1_first_name, :owner_2_first_name, :owner_2_last_name,
  # :property_address, :property_city, :property_state,
  # :property_zip_code, :mail_address, :mail_city, :mail_state, :mail_zip_code

  def self.search(search)
    if search
      where('LOWER(owner_1_first_name) LIKE LOWER(?) or LOWER(owner_1_last_name) LIKE ? or
      LOWER(owner_2_first_name) LIKE LOWER(?) or LOWER(owner_2_last_name) LIKE LOWER(?) or
      LOWER(property_address) LIKE LOWER(?) or LOWER(property_city) LIKE LOWER(?) or
      LOWER(property_state) LIKE LOWER(?) or LOWER(property_zip_code) LIKE LOWER(?) or
      LOWER(mail_address) LIKE LOWER(?) or LOWER(mail_city) LIKE LOWER(?) or
      LOWER(mail_state) LIKE LOWER(?) or LOWER(mail_zip_code) LIKE LOWER(?)',
      "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%",
      "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%",
      "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%")
    else
      all
    end
  end
end
