

[5,10,15,20,25,35,50,75,100,150].each do |m|
  Prospect.find_by_sql("select  p.id,p.owner_1_first_name,p.owner_1_last_name,p.mail_zip_code from prospect_user p join prospect_rental pr on  (pr.prospect_user_id=p.id)
where p.owner_1_label_name Not like '%Trust%' and p.owner_1_first_name!='NULL' and p.owner_1_last_name is not null and p.owner_1_first_name is not null and p.mail_zip_code is not null and  p.property_city in ('Incline Village','Kings Beach','Tahoe Vista','Truckee','Alpine Meadows','Squaw Valley','Olympic Valley','Carnelian Bay','Tahoe City','Tahoma','Homewood','Meeks Bay','Crystal Bay') and
      p.id not in (select  p.id from prospect_user p join prospect_rental pr on (pr.prospect_user_id=p.id)
        join prospect_linkedin pl on (pl.prospect_user_id=p.id) where  p.property_city in ('Incline Village','Kings Beach','Tahoe Vista','Truckee','Alpine Meadows','Squaw Valley','Olympic Valley','Carnelian Bay','Tahoe City','Tahoma','Homewood','Meeks Bay','Crystal Bay'))  order by p.id offset 1600 limit 400 ").each do |f|

    url = URI("https://www.linkedin.com/recruiter/api/smartsearch?firstName="+f.owner_1_first_name.gsub(" ","+")+"&lastName="+f.owner_1_last_name.gsub(" ","+")+"&radiusMiles=#{m}&countryCode=us&postalCode="+f.mail_zip_code)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["cookie"] = '_chartbeat2=BM6vX5BVJ_EHDCKVa7.1470370626983.1470370627063.1; visit=\"v=1&M\"; bcookie=\"v=2&724279ff-c4f1-44cb-88e8-fb28d625c55f\"; bscookie=\"v=1&201704191828201ce85440-2dd8-4427-8b44-da36c065aef0AQH4WMAGXOCIBvq_JIgnQxjCWOyGN-sx\"; __utma=226841088.595044668.1439331406.1456257870.1492730417.6; __utmz=226841088.1492730417.6.1.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); __utmv=226841088.user; lidc=\"b=OB01:g=222:u=300:i=1493254684:t=1493304435:s=AQEqs1gVEyZM7zUoYOuI0iMfEpgV59cV\"; SID=02db5000-9fce-406e-a8b1-cb91fe6955bd; VID=V_2017_04_26_18_352; u_tz=GMT-0700; cap_session_id=\"1637287381:1\"; li_a=AQJ2PTEmY2FwX3NlYXQ9OTE4Nzk3NzEmY2FwX2FkbWluPXRydWUmY2FwX2tuPTE4MjA4MTAxMa1HYRmcMVE1iKwyOopAw9mhLSXe; JSESSIONID=\"ajax:2304089223362039148\"; li_at=AQEDAQCdjTUBCXm-AAABW60zYKcAAAFbrurUp1YArWdfVP_0NNrlGRNUGKTAWnGwruco9OkcFSP4vEjcwlOTFOdKUOqZLpJY7IoTHa45q4bY1ITnAvLdbBXItsfprxrpnR7Ccg538pYGt-cVLvikBb98; sl=\"v=1&iDGnR\"; liap=true; _ga=GA1.2.595044668.1439331406; lang=\"v=2&lang=en-us\"; _lipt=CwEAAAFbrfF8R6QsuD6kh9my5cnI7BRNiYTYpXhnOThvuvHU5U3qg0fWrdrX6ePXCsXktgL-nYv9Vrjnn8-mRuvWJgpi7SUAiuZjwyCDsHt4SvFaf5BBqZ80s9R4LdT8_y5NqbYQHIUFOvtkfi_U19IGotmXVP8V_yJ4V08rdLdEvf7WD6jGDLkwRSZfvFS3DwDL8z58AoX-UUl3EycYUJ9Ecu3kFzGNtjKb0k4l_ITUovOETPai56jMPJvsoh4280VFl_VRyIlTOAmtSVWYKHNxX2py7yo3KHv9fLL5z6Qb8N-6Nv0N_stBr1Chg7C2MCJJRd-o-lwp9tBeS9I6IQ9YJykMdJ4qLOT2zBPvVoqQY151JDuFe-vmho6CXlZQ3Qv6FEv7D-J6XfyYhZflNFFYOdVJsHrelEolSOhMVMttnkAOTtyk5w73V9JIi_T3KtJGkpCo1XdJ1Zpt; sdsc=1%3A1SZM1shxDNbLt36wZwCgPgvN58iw%3D'
    request["cache-control"] = 'no-cache'

    response = http.request(request)
    begin
      h=JSON.parse(response.body)
    rescue JSON::ParserError => e
      p "Json malformed"
      next
    end

    p h["meta"]["total"]
    if  h["meta"]["total"]==1
       hit=Linkedin.where( prospect_user_id: f.id)
      if(hit.empty?)
        p f.owner_1_first_name.gsub(" ","+")+"&lastName="+f.owner_1_last_name.gsub(" ","+")
        p f.id
        pl = Linkedin.new
        pl.id=Linkedin.maximum(:id).next
        pl.prospect_user_id=f.id
        pl.company_name=h["result"]["searchResults"][0]["currentPositions"][0]["companyName"] rescue " "
        pl.as_url_param=h["result"]["searchResults"][0]["findAuthInputModel"]["asUrlParam"] rescue " "
        pl.save!
      end
    end
  end
end


[5,10,15,25,35,50,75,100,125,150,200].each do |m|
  Prospect.find_by_sql("select  p.id,p.owner_2_first_name,p.owner_2_last_name,p.mail_zip_code from prospect_user p join prospect_rental pr on  (pr.prospect_user_id=p.id)
  where p.owner_1_label_name Not like '%Trust%' and p.owner_2_first_name!='NULL' and p.owner_2_last_name is not null and p.owner_2_first_name is not null and p.mail_zip_code is not null and  p.property_city in ('Incline Village','Kings Beach','Tahoe Vista','Truckee','Alpine Meadows','Squaw Valley','Olympic Valley','Carnelian Bay','Tahoe City','Tahoma','Homewood','Meeks Bay','Crystal Bay') and
        p.id not in (select  p.id from prospect_user p join prospect_rental pr on (pr.prospect_user_id=p.id)
          join prospect_linkedin pl on (pl.prospect_user_id=p.id) where  p.property_city in ('Incline Village','Kings Beach','Tahoe Vista','Truckee','Alpine Meadows','Squaw Valley','Olympic Valley','Carnelian Bay','Tahoe City','Tahoma','Homewood','Meeks Bay','Crystal Bay'))").each do |f|
    url = URI("https://www.linkedin.com/recruiter/api/smartsearch?firstName="+f.owner_2_first_name.gsub(" ","+")+"&lastName="+f.owner_2_last_name.gsub(" ","+")+"&radiusMiles=#{m}&countryCode=us&postalCode="+f.mail_zip_code)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new(url)
    request["cookie"] = '_chartbeat2=BM6vX5BVJ_EHDCKVa7.1470370626983.1470370627063.1; visit=\"v=1&M\"; bcookie=\"v=2&724279ff-c4f1-44cb-88e8-fb28d625c55f\"; bscookie=\"v=1&201704191828201ce85440-2dd8-4427-8b44-da36c065aef0AQH4WMAGXOCIBvq_JIgnQxjCWOyGN-sx\"; __utma=226841088.595044668.1439331406.1456257870.1492730417.6; __utmz=226841088.1492730417.6.1.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); __utmv=226841088.user; lidc=\"b=OB01:g=222:u=300:i=1493254684:t=1493304435:s=AQEqs1gVEyZM7zUoYOuI0iMfEpgV59cV\"; SID=02db5000-9fce-406e-a8b1-cb91fe6955bd; VID=V_2017_04_26_18_352; u_tz=GMT-0700; cap_session_id=\"1637287381:1\"; li_a=AQJ2PTEmY2FwX3NlYXQ9OTE4Nzk3NzEmY2FwX2FkbWluPXRydWUmY2FwX2tuPTE4MjA4MTAxMa1HYRmcMVE1iKwyOopAw9mhLSXe; JSESSIONID=\"ajax:2304089223362039148\"; li_at=AQEDAQCdjTUBCXm-AAABW60zYKcAAAFbrurUp1YArWdfVP_0NNrlGRNUGKTAWnGwruco9OkcFSP4vEjcwlOTFOdKUOqZLpJY7IoTHa45q4bY1ITnAvLdbBXItsfprxrpnR7Ccg538pYGt-cVLvikBb98; sl=\"v=1&iDGnR\"; liap=true; _ga=GA1.2.595044668.1439331406; lang=\"v=2&lang=en-us\"; _lipt=CwEAAAFbrfF8R6QsuD6kh9my5cnI7BRNiYTYpXhnOThvuvHU5U3qg0fWrdrX6ePXCsXktgL-nYv9Vrjnn8-mRuvWJgpi7SUAiuZjwyCDsHt4SvFaf5BBqZ80s9R4LdT8_y5NqbYQHIUFOvtkfi_U19IGotmXVP8V_yJ4V08rdLdEvf7WD6jGDLkwRSZfvFS3DwDL8z58AoX-UUl3EycYUJ9Ecu3kFzGNtjKb0k4l_ITUovOETPai56jMPJvsoh4280VFl_VRyIlTOAmtSVWYKHNxX2py7yo3KHv9fLL5z6Qb8N-6Nv0N_stBr1Chg7C2MCJJRd-o-lwp9tBeS9I6IQ9YJykMdJ4qLOT2zBPvVoqQY151JDuFe-vmho6CXlZQ3Qv6FEv7D-J6XfyYhZflNFFYOdVJsHrelEolSOhMVMttnkAOTtyk5w73V9JIi_T3KtJGkpCo1XdJ1Zpt; sdsc=1%3A1SZM1shxDNbLt36wZwCgPgvN58iw%3D'
    request["cache-control"] = 'no-cache'

    response = http.request(request)
    begin
      h=JSON.parse(response.body)
    rescue JSON::ParserError => e
      p "Json malformed"
      next
    end
    p h["meta"]["total"]
    if  h["meta"]["total"]==1
       hit=Linkedin.where( prospect_user_id: f.id)
      if(hit.empty?)
        p f.owner_2_first_name.gsub(" ","+")+"&lastName="+f.owner_2_last_name.gsub(" ","+")
        p f.id
        pl = Linkedin.new
        pl.id=Linkedin.maximum(:id).next
        pl.prospect_user_id=f.id
        pl.second_owner_as_url_param=h["result"]["searchResults"][0]["findAuthInputModel"]["asUrlParam"] rescue " "
        pl.save!
      end
    end
  end
end

[1,2,3,4,5,6,7,8].each do  |m|
  Linkedin.find_by_sql("select substring(second_owner_as_url_param from  '(.*?),') as member_id,id from prospect_linkedin where  id>6627  and second_owner_as_url_param is not null and email_count is null limit 89;").each do |f|
  p f.member_id
  url = URI("https://contactout.com/api/profile/encrypted")
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Post.new(url)
  request["content-type"] = 'application/x-www-form-urlencoded'
  request["cache-control"] = 'no-cache'
  request["postman-token"] = 'dfbf1808-6c26-84c2-d750-3ebb19807eb7'
  request.body = "command=contact_out_encrypted_profile&member_id=#{f.member_id}&user=53447"

  response = http.request(request)
  res=JSON.parse(response.read_body)
  f.id =f.id
  f.email_count=res["data"].length
  f.save!
  sleep 2
  end
   sleep 120
end



[1,2,3,4,5,6,7,8].each do  |m|
Linkedin.find_by_sql("select substring(second_owner_as_url_param from  '(.*?),') as member_id,id,second_owner_email  from prospect_linkedin where  id>5420  and email_count=1 and second_owner_email is null  and second_owner_as_url_param is not null limit 89").each do |f|
p f.member_id
url = URI("https://contactout.com/api/profile/encrypted")
http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Post.new(url)
request["content-type"] = 'application/x-www-form-urlencoded'
request["cache-control"] = 'no-cache'
request["postman-token"] = 'dfbf1808-6c26-84c2-d750-3ebb19807eb7'
request.body = "command=contact_out_encrypted_profile&member_id=#{f.member_id}&user=53447"

response = http.request(request)
res=JSON.parse(response.read_body)
f.id =f.id
linkedin_user_key=res["data"][0]["key"]
sleep 2
dec_url = URI("https://contactout.com/api/profile/decrypted")

http = Net::HTTP.new(dec_url.host, dec_url.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Post.new(dec_url)
request["cookie"] = 'remember_web_59ba36addc2b2f9401580f014c7f58ea4e30989d=eyJpdiI6InRZcCtOVms4UGlSUHdmWXVocHVJcFE9PSIsInZhbHVlIjoiSUd3WEVDRjR6MDZpOHZNRERyT3dTXC90Ylh5Z1VwSE1SRjUyYjExM2F4UjR4TjRwQmFDdjF6bHVNbkdLNlpSZ05RMUl4KzYyZzJ1eGcwVlkzc3lHWjM2TWxZc3Uwc2tBMHdjdFFwK0VTNlpvPSIsIm1hYyI6ImY1MzE2MzU1MjYwYzk1NTcyMGI4YzllYzJlMmI5NzBhYTQ4NzU4ZWI4NzdmNDc5ZDZhMDNkMjkxYmYyYTVjYWUifQ%3D%3D; login_auth=eyJpdiI6IkhqTGhnZzJETGF0YWpaN1owUmlubkE9PSIsInZhbHVlIjoiN1FiRW41WXAzYjJYUUIzZ2ZYY1Y2Zz09IiwibWFjIjoiNzkxNWRkMDRiODJhY2EzMTk3NmZkNWRkZTBjNDUxZTczYTRhZDk1NDQxNGJjNDA3MmY4YWU1MmY1YTRkODFiZSJ9; _ga=GA1.2.1083936750.1495500808; _gid=GA1.2.335733637.1497555945; li_at=eyJpdiI6IklvMkl6UW9xZ1JyZjc2VG9JcjcyK1E9PSIsInZhbHVlIjoiTXdmQmVPZHZpS0w2MGYyVXBtRU4yXC9VY2lyRFc1Z2tnanE5a0JoaDFwQjA9IiwibWFjIjoiMzJmNjVmZGYwZTlkYzczMmRhODJkY2NiMzcxMmY4MTlkOTRmZjk1ZmMxMDcwN2FhZDgwM2JhNDIyMTEwYmEyNCJ9; XSRF-TOKEN=eyJpdiI6Ikx3ZmE1U0VRcHhPdXhGODIyQ0RTM0E9PSIsInZhbHVlIjoiOHcybzVMQ2lLZjNxUlBcL1BCdVZWdFhDbW52QWFiQTZlaGtFR2pXMzVQTGk3ZGMrXC9tQ3Brck9HdXI5M3VRb2I5R1lPQW10SmJVWkZmaGt1a0RRZVwvZkE9PSIsIm1hYyI6ImMxOWQ3NzIyYTJkZWJlMDNhZTFmNGFiZDFhMDIxODhlOWIxNzU5OWY4MWY1ZDU1ODVmN2M3ZmJkZmJiZDgzYTAifQ%3D%3D; laravel_session=eyJpdiI6Ijd0VFhzenNCb1dVeXpZYXNQSXZEVUE9PSIsInZhbHVlIjoiOFVmbVhOQWdYRStlYlwvNFdvSEpuSjNhZUNyMWhVbjE1UE1MdG53S1ZBcVJ0T2FaS0hYRmF5dlVhaExsSE1hUSs0ME1Ick5LbVVuWkRNTHNLK0tPQjZBPT0iLCJtYWMiOiIwNzFkMTRiMDQ0NGExNWU0MWRmNmY3NzdjNDcxNTgxNGVjZjdhMzM3ZjA0NTIzZTZjMGQ0MTY2MjMzZTkyNjM5In0%3D'
request["cache-control"] = 'no-cache'
request["postman-token"] = '025d51fb-9d7a-b5fd-99af-fec7513528d6'
request["content-type"] = 'application/x-www-form-urlencoded'
request.body = "command=contact_out_decrypted_profile&key%5B%5D=#{linkedin_user_key}&user=53447&version=2.3.4"

dec_response = http.request(request)
dec_res=JSON.parse(dec_response.read_body)
p dec_res
f.second_owner_email=dec_res[linkedin_user_key]
f.save!
sleep 2
end
   sleep 120
end


Linkedin.find_by_sql("select substring(second_owner_as_url_param from  '(.*?),') as member_id,id,email,email_count from prospect_linkedin where  email_count=2 and second_owner_email is null  and second_owner_as_url_param is not null limit 89;").each do |f|
p f.member_id
url = URI("https://contactout.com/api/profile/encrypted")
http = Net::HTTP.new(url.host, url.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Post.new(url)
request["content-type"] = 'application/x-www-form-urlencoded'
request["cache-control"] = 'no-cache'
request["postman-token"] = 'dfbf1808-6c26-84c2-d750-3ebb19807eb7'
request.body = "command=contact_out_encrypted_profile&member_id=#{f.member_id}&user=53447"

response = http.request(request)
res=JSON.parse(response.read_body)
f.id =f.id
linkedin_user_key1=res["data"][0]["key"]
linkedin_user_key2=res["data"][1]["key"]
dec_url = URI("https://contactout.com/api/profile/decrypted")

http = Net::HTTP.new(dec_url.host, dec_url.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Post.new(dec_url)
request["cookie"] = 'remember_web_59ba36addc2b2f9401580f014c7f58ea4e30989d=eyJpdiI6InRZcCtOVms4UGlSUHdmWXVocHVJcFE9PSIsInZhbHVlIjoiSUd3WEVDRjR6MDZpOHZNRERyT3dTXC90Ylh5Z1VwSE1SRjUyYjExM2F4UjR4TjRwQmFDdjF6bHVNbkdLNlpSZ05RMUl4KzYyZzJ1eGcwVlkzc3lHWjM2TWxZc3Uwc2tBMHdjdFFwK0VTNlpvPSIsIm1hYyI6ImY1MzE2MzU1MjYwYzk1NTcyMGI4YzllYzJlMmI5NzBhYTQ4NzU4ZWI4NzdmNDc5ZDZhMDNkMjkxYmYyYTVjYWUifQ%3D%3D; login_auth=eyJpdiI6IkhqTGhnZzJETGF0YWpaN1owUmlubkE9PSIsInZhbHVlIjoiN1FiRW41WXAzYjJYUUIzZ2ZYY1Y2Zz09IiwibWFjIjoiNzkxNWRkMDRiODJhY2EzMTk3NmZkNWRkZTBjNDUxZTczYTRhZDk1NDQxNGJjNDA3MmY4YWU1MmY1YTRkODFiZSJ9; _ga=GA1.2.1083936750.1495500808; _gid=GA1.2.335733637.1497555945; li_at=eyJpdiI6IklvMkl6UW9xZ1JyZjc2VG9JcjcyK1E9PSIsInZhbHVlIjoiTXdmQmVPZHZpS0w2MGYyVXBtRU4yXC9VY2lyRFc1Z2tnanE5a0JoaDFwQjA9IiwibWFjIjoiMzJmNjVmZGYwZTlkYzczMmRhODJkY2NiMzcxMmY4MTlkOTRmZjk1ZmMxMDcwN2FhZDgwM2JhNDIyMTEwYmEyNCJ9; XSRF-TOKEN=eyJpdiI6Ikx3ZmE1U0VRcHhPdXhGODIyQ0RTM0E9PSIsInZhbHVlIjoiOHcybzVMQ2lLZjNxUlBcL1BCdVZWdFhDbW52QWFiQTZlaGtFR2pXMzVQTGk3ZGMrXC9tQ3Brck9HdXI5M3VRb2I5R1lPQW10SmJVWkZmaGt1a0RRZVwvZkE9PSIsIm1hYyI6ImMxOWQ3NzIyYTJkZWJlMDNhZTFmNGFiZDFhMDIxODhlOWIxNzU5OWY4MWY1ZDU1ODVmN2M3ZmJkZmJiZDgzYTAifQ%3D%3D; laravel_session=eyJpdiI6Ijd0VFhzenNCb1dVeXpZYXNQSXZEVUE9PSIsInZhbHVlIjoiOFVmbVhOQWdYRStlYlwvNFdvSEpuSjNhZUNyMWhVbjE1UE1MdG53S1ZBcVJ0T2FaS0hYRmF5dlVhaExsSE1hUSs0ME1Ick5LbVVuWkRNTHNLK0tPQjZBPT0iLCJtYWMiOiIwNzFkMTRiMDQ0NGExNWU0MWRmNmY3NzdjNDcxNTgxNGVjZjdhMzM3ZjA0NTIzZTZjMGQ0MTY2MjMzZTkyNjM5In0%3D'
request["cache-control"] = 'no-cache'
request["postman-token"] = '025d51fb-9d7a-b5fd-99af-fec7513528d6'
request["content-type"] = 'application/x-www-form-urlencoded'
request.body = "command=contact_out_decrypted_profile&key%5B%5D=#{linkedin_user_key1}&user=53447&version=2.3.4"

dec_response = http.request(request)
dec_res=JSON.parse(dec_response.read_body)
p dec_res
f.second_owner_email=dec_res[linkedin_user_key1]

dec_url = URI("https://contactout.com/api/profile/decrypted")

http = Net::HTTP.new(dec_url.host, dec_url.port)
http.use_ssl = true
http.verify_mode = OpenSSL::SSL::VERIFY_NONE

request = Net::HTTP::Post.new(dec_url)
request["cookie"] = 'remember_web_59ba36addc2b2f9401580f014c7f58ea4e30989d=eyJpdiI6InRZcCtOVms4UGlSUHdmWXVocHVJcFE9PSIsInZhbHVlIjoiSUd3WEVDRjR6MDZpOHZNRERyT3dTXC90Ylh5Z1VwSE1SRjUyYjExM2F4UjR4TjRwQmFDdjF6bHVNbkdLNlpSZ05RMUl4KzYyZzJ1eGcwVlkzc3lHWjM2TWxZc3Uwc2tBMHdjdFFwK0VTNlpvPSIsIm1hYyI6ImY1MzE2MzU1MjYwYzk1NTcyMGI4YzllYzJlMmI5NzBhYTQ4NzU4ZWI4NzdmNDc5ZDZhMDNkMjkxYmYyYTVjYWUifQ%3D%3D; login_auth=eyJpdiI6IkhqTGhnZzJETGF0YWpaN1owUmlubkE9PSIsInZhbHVlIjoiN1FiRW41WXAzYjJYUUIzZ2ZYY1Y2Zz09IiwibWFjIjoiNzkxNWRkMDRiODJhY2EzMTk3NmZkNWRkZTBjNDUxZTczYTRhZDk1NDQxNGJjNDA3MmY4YWU1MmY1YTRkODFiZSJ9; _ga=GA1.2.1083936750.1495500808; _gid=GA1.2.335733637.1497555945; li_at=eyJpdiI6IklvMkl6UW9xZ1JyZjc2VG9JcjcyK1E9PSIsInZhbHVlIjoiTXdmQmVPZHZpS0w2MGYyVXBtRU4yXC9VY2lyRFc1Z2tnanE5a0JoaDFwQjA9IiwibWFjIjoiMzJmNjVmZGYwZTlkYzczMmRhODJkY2NiMzcxMmY4MTlkOTRmZjk1ZmMxMDcwN2FhZDgwM2JhNDIyMTEwYmEyNCJ9; XSRF-TOKEN=eyJpdiI6Ikx3ZmE1U0VRcHhPdXhGODIyQ0RTM0E9PSIsInZhbHVlIjoiOHcybzVMQ2lLZjNxUlBcL1BCdVZWdFhDbW52QWFiQTZlaGtFR2pXMzVQTGk3ZGMrXC9tQ3Brck9HdXI5M3VRb2I5R1lPQW10SmJVWkZmaGt1a0RRZVwvZkE9PSIsIm1hYyI6ImMxOWQ3NzIyYTJkZWJlMDNhZTFmNGFiZDFhMDIxODhlOWIxNzU5OWY4MWY1ZDU1ODVmN2M3ZmJkZmJiZDgzYTAifQ%3D%3D; laravel_session=eyJpdiI6Ijd0VFhzenNCb1dVeXpZYXNQSXZEVUE9PSIsInZhbHVlIjoiOFVmbVhOQWdYRStlYlwvNFdvSEpuSjNhZUNyMWhVbjE1UE1MdG53S1ZBcVJ0T2FaS0hYRmF5dlVhaExsSE1hUSs0ME1Ick5LbVVuWkRNTHNLK0tPQjZBPT0iLCJtYWMiOiIwNzFkMTRiMDQ0NGExNWU0MWRmNmY3NzdjNDcxNTgxNGVjZjdhMzM3ZjA0NTIzZTZjMGQ0MTY2MjMzZTkyNjM5In0%3D'
request["cache-control"] = 'no-cache'
request["postman-token"] = '025d51fb-9d7a-b5fd-99af-fec7513528d6'
request["content-type"] = 'application/x-www-form-urlencoded'
request.body = "command=contact_out_decrypted_profile&key%5B%5D=#{linkedin_user_key2}&user=53447&version=2.3.4"

dec_response = http.request(request)
dec_res=JSON.parse(dec_response.read_body)
p dec_res
f.notes=dec_res[linkedin_user_key2]

f.save!
end
