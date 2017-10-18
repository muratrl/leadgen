last_scripts.ru psql `heroku config:get HEROKU_POSTGRESQL_BRONZE_URL  -a rl-leadgen`?ssl=true -c "\copy prospects (property_address,owner_1_last_name,owner_1_first_name,mail_address,mail_city,owner_2_first_name,owner_2_last_name,mail_state,mail_zip_code,property_cuty,property_state,property_zip) FROM 'second_batch.csv' DELIMITER ',' CSV;"



require 'net/http'
 [5,10,25,35,50,100,150,200].each do |m|
  Lead.find_by_sql("select prospect_id,owner_1_first_name,owner_1_last_name,mail_zip_code from prospects where prospect_id>1000 and prospect_id<1501 order by prospect_id;").each do |f|


    url = URI("https://www.linkedin.com/recruiter/api/smartsearch?firstName="+f.owner_1_first_name.gsub(" ","+")+"&lastName="+f.owner_1_last_name.gsub(" ","+")+"&radiusMiles=#{m}&countryCode=us&postalCode="+f.mail_zip_code)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["cookie"] = 'bcookie=\"v=2&0efefc6f-031c-4316-80ed-16fc14c76b10\"; bscookie=\"v=1&2017061519414001a5015e-1771-42a6-8487-90a810a7d01dAQFKwr1A8jnxNsfwkSgcQSgjOwbxagfr\"; visit=\"v=1&M\"; lidc=\"b=OB01:g=567:u=373:i=1507655850:t=1507742250:s=AQGI2kK3xOlO7Giu9K86fJB1ZD6GfIow\"; _gat=1; _ga=GA1.2.366240973.1498073455; _lipt=CwEAAAFfCf3C9IlOrz4Hy5MvsrsdoVKjQu5l5njPiIYfMA5PJo8syXwDa3puiWPioZNAuzfq4-0lR0AQFHUy84npNViaPuA2hKoV2vX1VMYE0pcZK8UXmaMJjH9admQMCP8KhYQqdIfcmAKzGWF8a85o132CoxDqtVFDnfFTM973syqowaL3G61uXqIKWO4-q_TQDEVhnLwUczI-c0aY97GZoC9fsQ7PDZjJXrSi2FoL9VjRhFMX40IsnA9VEbOp7bzpGi2tL46r_tDC3nCIX9l49foPAT9g63UJAXY1yo0Bb6kOqu9uBIuxHwgLYI8LjmIh3C5KTDR0Dt00lPpUAtWEqy1Z2HrzYkhYOTSEuWAvPQGLy3AS4JCggKlSI9aQee8dEe5P-UmrnOk87tKOFqXqUKcKpFHEQDXRVcfskwrmX-9-Z7VeOn8ae85cFxu9nxObQsXw; u_tz=GMT-0700; li_at=AQEDAQCdjTUDhMM4AAABXwn_kjIAAAFfLgwWMlYAujwVJh0ZGH4jkaHk_kKkJ0Q6-XuyewHtdC3bEZ-daGTlxfkvX_qMTzAJDbgbKTc4on2rmCJBV1DUCfPGo0xhJVu-ecQKC-yeUvp3LmGtPgGbTPpC; liap=true; sl=\"v=1&GDmnD\"; cap_session_id=\"1760809241:1\"; li_a=AQJ2PTEmY2FwX3NlYXQ9OTE4Nzk3NzEmY2FwX2FkbWluPXRydWUmY2FwX2tuPTE4MjA4MTAxMW64hGohU5yZnNCB_rfVWno-G6fz; JSESSIONID=\"ajax:1833331514969124406\"; RT=s=1507701359641&r=https%3A%2F%2Fwww.linkedin.com%2Fcap%2Fdashboard%2Fhome%3FrecruiterEntryPoint%3Dtrue%26trk%3Dnav_account_sub_nav_cap; lang=v=2&lang=en-US; sdsc=34%3A1%2C1507701332939%7ECAOR%2C0%7ECAST%2C-67514e96hPGVXepJ3Ebcs%2FeS1dvoxYAc%3D'
    request["cache-control"] = 'no-cache'

    response = http.request(request)
    p response
    h=JSON.parse(response.body)
    case m
    when 5
    f.five_radius=h["meta"]["total"]
    when 10
    f.ten_radius=h["meta"]["total"]
    when 25
    f.twenty_five_radius=h["meta"]["total"]
    when 35
    f.thirty_five_radius=h["meta"]["total"]
    when 50
    f.fifty_radius=h["meta"]["total"]
    when 100
    f.hundred_radius=h["meta"]["total"]
    when 150
    f.hundred_fifty_radius=h["meta"]["total"]
    when 200
    f.two_hundred_radius=h["meta"]["total"]
    else
    p "somewhere else"
    end


    if  h["meta"]["total"]==1
        p f.id
        f.linkedin_recruiter_url="https://www.linkedin.com/recruiter/profile/"+h["result"]["searchResults"][0]["findAuthInputModel"]["asUrlParam"] rescue " "
    end
    f.is_run=true
    f.save
  end
end


Lead.find_by_sql("select prospect_id,linkedin_recruiter_url,linkedin_public_url
from prospects where is_public_url_run is null  and prospects.is_run=true
and linkedin_recruiter_url is not null;").each do |f|

url = URI(f.linkedin_recruiter_url)
p url
http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Get.new(url)
request["cookie"] = 'bcookie=\"v=2&0efefc6f-031c-4316-80ed-16fc14c76b10\"; bscookie=\"v=1&2017061519414001a5015e-1771-42a6-8487-90a810a7d01dAQFKwr1A8jnxNsfwkSgcQSgjOwbxagfr\"; visit=\"v=1&M\"; lidc=\"b=OB01:g=567:u=373:i=1507655850:t=1507742250:s=AQGI2kK3xOlO7Giu9K86fJB1ZD6GfIow\"; _gat=1; _ga=GA1.2.366240973.1498073455; _lipt=CwEAAAFfCf3C9IlOrz4Hy5MvsrsdoVKjQu5l5njPiIYfMA5PJo8syXwDa3puiWPioZNAuzfq4-0lR0AQFHUy84npNViaPuA2hKoV2vX1VMYE0pcZK8UXmaMJjH9admQMCP8KhYQqdIfcmAKzGWF8a85o132CoxDqtVFDnfFTM973syqowaL3G61uXqIKWO4-q_TQDEVhnLwUczI-c0aY97GZoC9fsQ7PDZjJXrSi2FoL9VjRhFMX40IsnA9VEbOp7bzpGi2tL46r_tDC3nCIX9l49foPAT9g63UJAXY1yo0Bb6kOqu9uBIuxHwgLYI8LjmIh3C5KTDR0Dt00lPpUAtWEqy1Z2HrzYkhYOTSEuWAvPQGLy3AS4JCggKlSI9aQee8dEe5P-UmrnOk87tKOFqXqUKcKpFHEQDXRVcfskwrmX-9-Z7VeOn8ae85cFxu9nxObQsXw; u_tz=GMT-0700; li_at=AQEDAQCdjTUDhMM4AAABXwn_kjIAAAFfLgwWMlYAujwVJh0ZGH4jkaHk_kKkJ0Q6-XuyewHtdC3bEZ-daGTlxfkvX_qMTzAJDbgbKTc4on2rmCJBV1DUCfPGo0xhJVu-ecQKC-yeUvp3LmGtPgGbTPpC; liap=true; sl=\"v=1&GDmnD\"; cap_session_id=\"1760809241:1\"; li_a=AQJ2PTEmY2FwX3NlYXQ9OTE4Nzk3NzEmY2FwX2FkbWluPXRydWUmY2FwX2tuPTE4MjA4MTAxMW64hGohU5yZnNCB_rfVWno-G6fz; JSESSIONID=\"ajax:1833331514969124406\"; RT=s=1507701359641&r=https%3A%2F%2Fwww.linkedin.com%2Fcap%2Fdashboard%2Fhome%3FrecruiterEntryPoint%3Dtrue%26trk%3Dnav_account_sub_nav_cap; lang=v=2&lang=en-US; sdsc=34%3A1%2C1507701332939%7ECAOR%2C0%7ECAST%2C-67514e96hPGVXepJ3Ebcs%2FeS1dvoxYAc%3D'
request["cache-control"] = 'no-cache'

response = http.request(request)
p response

public_url=response.body.split("publicLink")[1]
if !public_url.nil?
  zt=public_url.split("isJobSeeker")[0]
  tt= zt.match(/http\S{1,}\",/)
  tz=tt.to_s[0,tt.to_s.length-2]
  p tz
  f.linkedin_public_url=tz

end
f.is_public_url_run=true;
f.save
end

require 'net/http'
require 'json'

Lead.find_by_sql("select * from prospects where linkedin_recruiter_url is not null ").each do |f|

url = URI("http://www.zillow.com/webservice/GetDeepSearchResults.htm?zws-id=X1-ZWz1g1el9x7zm3_3csw9&address="+f.property_address.gsub(" ", "+")+"&citystatezip="+f.property_city.gsub(" ","+")+"+"+f.property_state)
http = Net::HTTP.new(url.host, url.port)
request = Net::HTTP::Get.new(url)

response = http.request(request)
zd=Hash.from_xml(response.body).to_json
f.zillow_json=zd
f.save
end







