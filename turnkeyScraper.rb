require 'mail'
require 'csv'
require 'httparty'
require 'pp'


turnkey_csv = File.new("turnkey_south_lake_tahoe_homes.csv", "a+")
CSV.foreach('turnkey_south_lake_tahoe_links.csv') do |row|
  p row[0]
  response=HTTParty.get row[0]
  propertyId=response.body.match(/propId = '\S+'/)
  propId=propertyId[0].split("=")[1][2..-2]
  p propId
  propertyDetails= HTTParty.post("https://www.turnkeyvr.com/mainDataClient/getPropertyDetail",
   body: { propertyId: propId.to_s},
   :headers =>  {"Content_type" => "application/xml; charset=utf-8"})
  propDetailsJson=propertyDetails.parsed_response
  address=URI.decode(propDetailsJson["AddressUrlEncoded"])
  bedrooms=propDetailsJson["Bedrooms"]
  bed_string=propDetailsJson["BedString"]
  bathrooms=propDetailsJson["Bathrooms"]
  bath_string=propDetailsJson["BathString"]
  p address
  CSV.open(turnkey_csv, 'a+' ) do |writer|
    writer << [propId,address,bedrooms,bed_string,bathrooms,bath_string]
  end
end
