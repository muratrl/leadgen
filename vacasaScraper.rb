require 'mail'
require 'csv'
require 'httparty'
require 'pp'


turnkey_csv = File.new("vacasa_north_lake_tahoe_homes.csv", "a+")
CSV.foreach('vacasa_north_lake_tahoe_links.csv') do |row|
  p row[0]
  response=HTTParty.get row[0]
  # p response

  strettAddressBlob=response.parsed_response.match(/streetAddress.*<\//)[0].split(">")[1].split("<")[0]
  addressLocality=response.parsed_response.match(/addressLocality.*<\//)[0].split(">")[1].split("<")[0]
  addressRegion=response.parsed_response.match(/addressRegion.*<\//)[0].split(">")[1].split("<")[0]
  addressPostalCode=response.parsed_response.match(/postalCode.*<\//)[0].split(">")[1].split("<")[0]
  bedrooms=response.parsed_response.match(/Bedrooms:<\/b>.*/)[0].split("</b>")[1].split("\"")[0]
  bathrooms=response.parsed_response.match(/Bathrooms:<\/b>.*/)[0].split("</b>")[1].split("\"")[0]
  beds=response.parsed_response.match(/Beds:<\/b>.*/)[0].split("</b>")[1].split("\"")[0]


  p strettAddressBlob
  p addressLocality
  p addressRegion
  p addressPostalCode
  p beds
  p bedrooms
  p bathrooms

  CSV.open(turnkey_csv, 'a+' ) do |writer|
    writer << [row[0],strettAddressBlob+" "+addressLocality+" "+addressRegion+ " " +addressPostalCode ,bedrooms,beds,bathrooms]
  end
end
