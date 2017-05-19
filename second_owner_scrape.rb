require 'net/http'
Prospect.joins("left  join prospect_linkedin pl on(prospect_user.id=pl.prospect_user_id) join prospect_rental pr on (prospect_user.id=pr.prospect_user_id)").where("property_city ='South Lake Tahoe' and pl.prospect_user_id is null and owner_2_last_name is not null and owner_2_first_name is not null and mail_zip_code is not null and zestimate!='$0.00'").offset(400).first(200).each do |f|
  url = URI("https://www.linkedin.com/recruiter/api/smartsearch?firstName="+f.owner_2_first_name.gsub(" ","+")+"&lastName="+f.owner_2_last_name.gsub(" ","+")+"&radiusMiles=10&countryCode=us&postalCode="+f.mail_zip_code)
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(url)
  request["cookie"] = '_chartbeat2=BM6vX5BVJ_EHDCKVa7.1470370626983.1470370627063.1; visit=\"v=1&M\"; bcookie=\"v=2&724279ff-c4f1-44cb-88e8-fb28d625c55f\"; bscookie=\"v=1&201704191828201ce85440-2dd8-4427-8b44-da36c065aef0AQH4WMAGXOCIBvq_JIgnQxjCWOyGN-sx\"; __utma=226841088.595044668.1439331406.1456257870.1492730417.6; __utmz=226841088.1492730417.6.1.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); __utmv=226841088.user; lidc=\"b=OB01:g=222:u=300:i=1493254684:t=1493304435:s=AQEqs1gVEyZM7zUoYOuI0iMfEpgV59cV\"; SID=02db5000-9fce-406e-a8b1-cb91fe6955bd; VID=V_2017_04_26_18_352; u_tz=GMT-0700; cap_session_id=\"1637287381:1\"; li_a=AQJ2PTEmY2FwX3NlYXQ9OTE4Nzk3NzEmY2FwX2FkbWluPXRydWUmY2FwX2tuPTE4MjA4MTAxMa1HYRmcMVE1iKwyOopAw9mhLSXe; JSESSIONID=\"ajax:2304089223362039148\"; li_at=AQEDAQCdjTUBCXm-AAABW60zYKcAAAFbrurUp1YArWdfVP_0NNrlGRNUGKTAWnGwruco9OkcFSP4vEjcwlOTFOdKUOqZLpJY7IoTHa45q4bY1ITnAvLdbBXItsfprxrpnR7Ccg538pYGt-cVLvikBb98; sl=\"v=1&iDGnR\"; liap=true; _ga=GA1.2.595044668.1439331406; lang=\"v=2&lang=en-us\"; _lipt=CwEAAAFbrfF8R6QsuD6kh9my5cnI7BRNiYTYpXhnOThvuvHU5U3qg0fWrdrX6ePXCsXktgL-nYv9Vrjnn8-mRuvWJgpi7SUAiuZjwyCDsHt4SvFaf5BBqZ80s9R4LdT8_y5NqbYQHIUFOvtkfi_U19IGotmXVP8V_yJ4V08rdLdEvf7WD6jGDLkwRSZfvFS3DwDL8z58AoX-UUl3EycYUJ9Ecu3kFzGNtjKb0k4l_ITUovOETPai56jMPJvsoh4280VFl_VRyIlTOAmtSVWYKHNxX2py7yo3KHv9fLL5z6Qb8N-6Nv0N_stBr1Chg7C2MCJJRd-o-lwp9tBeS9I6IQ9YJykMdJ4qLOT2zBPvVoqQY151JDuFe-vmho6CXlZQ3Qv6FEv7D-J6XfyYhZflNFFYOdVJsHrelEolSOhMVMttnkAOTtyk5w73V9JIi_T3KtJGkpCo1XdJ1Zpt; sdsc=1%3A1SZM1shxDNbLt36wZwCgPgvN58iw%3D'
  request["cache-control"] = 'no-cache'

  response = http.request(request)
  h=JSON.parse(response.body)
  p h["meta"]["total"]
  if  h["meta"]["total"]==1
    l1=Linkedin.where('prospect_user_id=?',f.id)
    p l1
    p l1.length>0
    if l1.length>0
      l1.second_owner_as_url_param=h["result"]["searchResults"][0]["findAuthInputModel"]["asUrlParam"] rescue " "
      l1.save!
    else
      p "here"
      pl = Linkedin.new
      pl.id=Linkedin.maximum(:id).next
      pl.prospect_user_id=f.id
      pl.second_owner_as_url_param=h["result"]["searchResults"][0]["findAuthInputModel"]["asUrlParam"] rescue " "
      pl.save!
    end
  end
end

Linkedin.where(" second_owner_as_url_param is not  null and second_owner_email is null and second_owner_public_linkedin_url is null").offset(23).each do |f|
  p f.as_url_param
  url = URI("https://www.linkedin.com/recruiter/profile/"+f.second_owner_as_url_param)
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_NONE

  request = Net::HTTP::Get.new(url)
  request["cookie"] = '_chartbeat2=BM6vX5BVJ_EHDCKVa7.1470370626983.1470370627063.1; visit=\"v=1&M\"; bcookie=\"v=2&724279ff-c4f1-44cb-88e8-fb28d625c55f\"; bscookie=\"v=1&201704191828201ce85440-2dd8-4427-8b44-da36c065aef0AQH4WMAGXOCIBvq_JIgnQxjCWOyGN-sx\"; __utma=226841088.595044668.1439331406.1456257870.1492730417.6; __utmz=226841088.1492730417.6.1.utmcsr=google|utmccn=(organic)|utmcmd=organic|utmctr=(not%20provided); __utmv=226841088.user; lidc=\"b=OB01:g=222:u=300:i=1493254684:t=1493304435:s=AQEqs1gVEyZM7zUoYOuI0iMfEpgV59cV\"; SID=02db5000-9fce-406e-a8b1-cb91fe6955bd; VID=V_2017_04_26_18_352; u_tz=GMT-0700; cap_session_id=\"1637287381:1\"; li_a=AQJ2PTEmY2FwX3NlYXQ9OTE4Nzk3NzEmY2FwX2FkbWluPXRydWUmY2FwX2tuPTE4MjA4MTAxMa1HYRmcMVE1iKwyOopAw9mhLSXe; JSESSIONID=\"ajax:2304089223362039148\"; li_at=AQEDAQCdjTUBCXm-AAABW60zYKcAAAFbrurUp1YArWdfVP_0NNrlGRNUGKTAWnGwruco9OkcFSP4vEjcwlOTFOdKUOqZLpJY7IoTHa45q4bY1ITnAvLdbBXItsfprxrpnR7Ccg538pYGt-cVLvikBb98; sl=\"v=1&iDGnR\"; liap=true; _ga=GA1.2.595044668.1439331406; lang=\"v=2&lang=en-us\"; _lipt=CwEAAAFbrfF8R6QsuD6kh9my5cnI7BRNiYTYpXhnOThvuvHU5U3qg0fWrdrX6ePXCsXktgL-nYv9Vrjnn8-mRuvWJgpi7SUAiuZjwyCDsHt4SvFaf5BBqZ80s9R4LdT8_y5NqbYQHIUFOvtkfi_U19IGotmXVP8V_yJ4V08rdLdEvf7WD6jGDLkwRSZfvFS3DwDL8z58AoX-UUl3EycYUJ9Ecu3kFzGNtjKb0k4l_ITUovOETPai56jMPJvsoh4280VFl_VRyIlTOAmtSVWYKHNxX2py7yo3KHv9fLL5z6Qb8N-6Nv0N_stBr1Chg7C2MCJJRd-o-lwp9tBeS9I6IQ9YJykMdJ4qLOT2zBPvVoqQY151JDuFe-vmho6CXlZQ3Qv6FEv7D-J6XfyYhZflNFFYOdVJsHrelEolSOhMVMttnkAOTtyk5w73V9JIi_T3KtJGkpCo1XdJ1Zpt; sdsc=1%3A1SZM1shxDNbLt36wZwCgPgvN58iw%3D'
  request["cache-control"] = 'no-cache'

  response = http.request(request)
  p response
  public_url=response.body.split("publicLink")[1]
  if !public_url.nil?
    zt=public_url.split("isJobSeeker")[0]
    tt= zt.match(/http\S{1,}\",/)
    tz=tt.to_s[0,tt.to_s.length-1]
    p tz
    f.second_owner_public_linkedin_url=tz
    f.save!
  end
end
