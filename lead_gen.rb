require 'net/http'
[5, 10, 25, 35, 50, 100, 150, 200].each do |m|
  begin
    Lead.find_by_sql("select prospect_id,owner_1_first_name,owner_1_last_name,mail_zip_code from prospects where is_run is null limit 1;").each do |f|

      begin
        url = URI("https://www.linkedin.com/recruiter/api/smartsearch?firstName="+f.owner_1_first_name.gsub(" ", "+")+"&lastName="+f.owner_1_last_name.gsub(" ", "+")+"&radiusMiles=#{m}&countryCode=us&postalCode="+f.mail_zip_code)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new(url)
        request["cookie"] = 'bcookie=\"v=2&0efefc6f-031c-4316-80ed-16fc14c76b10\"; bscookie=\"v=1&2017061519414001a5015e-1771-42a6-8487-90a810a7d01dAQFKwr1A8jnxNsfwkSgcQSgjOwbxagfr\"; visit=\"v=1&M\"; u_tz=GMT-0700; _lipt=CwEAAAFfJmLdQvVoGiaPLAdrqv2fqLG0RQ68SQ3jJj6a4DbCG9ox3EQGwcuC5EIXZDcttyxtBYv5462k4_nMJmk-FcHPTBfY2sg4-FKdqJHzBPfJlTRP3Dcm6qlyoRRsBZz-o-zienV2u4ifAhaMx-tLVyQToX-v6NkxgoN5RIXjRZSGfiXV-_EQeLPKPmBsMaJrL_2le8KLfTl7KCklFEouStviTRs9kyV93PY7I8DwZDc09QOM-P-5eP00zIWS4uyE2Q3XMXM1I8OLaNF_ZTffqVhJj9pYV2GI3jRqZxWtNckGnnREBKQrRXUHKgUAOGWEIGdlrTo3MOXstfjnlIdrpX3KeHRABnd_2I_T4zCf_otuaQ5pHamRcL6R8iaCQZCQFucB5KjvlMEaDqbb6vmCIBfUxuAXWJg_RJtMjgpueZFLZt_-riOT9HlHkWpaDqU; lidc=\"b=OB01:g=588:u=380:i=1508199235:t=1508284005:s=AQEN4mxslFoZKWVBMqfMUaDaFCOffWvM\"; _ga=GA1.2.366240973.1498073455; _gat=1; sl=\"v=1&M7jTE\"; li_at=AQEDAQCdjTUAYMsqAAABXyeuWBYAAAFfS7rcFlYAHoWW0uFPUX6HgNWEjeZJOY6_TZw5-r5ssrDz3MaNP5M-SeTIGqu3HRbYn6JLVppt_UMEJ2YyNyOm_GsdYnFYdezJdCDTGI2LIQfaFhXSAHAimOvP; liap=true; cap_session_id=\"1765663021:1\"; li_a=AQJ2PTEmY2FwX3NlYXQ9OTE4Nzk3NzEmY2FwX2FkbWluPXRydWUmY2FwX2tuPTE4MjA4MTAxMaOOMc6yEqAJ-7Ruw23kM5-bW99u; JSESSIONID=\"ajax:1833331514969124406\"; RT=s=1508199262921&r=https%3A%2F%2Fwww.linkedin.com%2Fcap%2Fdashboard%2Fhome%3FrecruiterEntryPoint%3Dtrue%26trk%3Dnav_account_sub_nav_cap; lang=\"v=2&lang=en-us\"; sdsc=31%3A1%2C1508199258716%7ECAOR%2C0%7ECAST%2C-42JeNnrisutrkmpKQNn9nWl71hqI4%3D; bcookie=\"v=2&0efefc6f-031c-4316-80ed-16fc14c76b10\"; visit=\"v=1&M\"; u_tz=GMT-0700; _lipt=CwEAAAFfJmLdQvVoGiaPLAdrqv2fqLG0RQ68SQ3jJj6a4DbCG9ox3EQGwcuC5EIXZDcttyxtBYv5462k4_nMJmk-FcHPTBfY2sg4-FKdqJHzBPfJlTRP3Dcm6qlyoRRsBZz-o-zienV2u4ifAhaMx-tLVyQToX-v6NkxgoN5RIXjRZSGfiXV-_EQeLPKPmBsMaJrL_2le8KLfTl7KCklFEouStviTRs9kyV93PY7I8DwZDc09QOM-P-5eP00zIWS4uyE2Q3XMXM1I8OLaNF_ZTffqVhJj9pYV2GI3jRqZxWtNckGnnREBKQrRXUHKgUAOGWEIGdlrTo3MOXstfjnlIdrpX3KeHRABnd_2I_T4zCf_otuaQ5pHamRcL6R8iaCQZCQFucB5KjvlMEaDqbb6vmCIBfUxuAXWJg_RJtMjgpueZFLZt_-riOT9HlHkWpaDqU; lidc=\"b=OB01:g=602:u=387:i=1508364009:t=1508426355:s=AQEMxz4jnl2MSvei0NBrqip8MhPBvc8Y\"; _ga=GA1.2.366240973.1498073455; _gat=1; liap=true; sl=\"v=1&lsXCl\"; li_at=AQEDAQCdjTUE1i1EAAABXzGAXeQAAAFfVYzh5FYArELkzipCk3hxY2603rVhGXx8kZTqdbMGXVCbFILeMfxbBAJDZTOa4F2tmf5lj27aaRVuwlyWGsFgJ9k-ycOFesv7w-Y7RNwmbBeLVpxp2szPMOqJ; cap_session_id=\"1767924321:1\"; li_a=AQJ2PTEmY2FwX3NlYXQ9OTE4Nzk3NzEmY2FwX2FkbWluPXRydWUmY2FwX2tuPTE4MjA4MTAxMTu_anVj_Iy8Jw6PtIYTAxJeqDjL; JSESSIONID=\"ajax:1833331514969124406\"; RT=s=1508364024784&r=https%3A%2F%2Fwww.linkedin.com%2Fcap%2Fdashboard%2Fhome%3FrecruiterEntryPoint%3Dtrue%26trk%3Dnav_account_sub_nav_cap; lang=v=2&lang=en-US; sdsc=31%3A1%2C1508364017777%7ECAOR%2C0%7ECAST%2C-408OdAobSkXCjpV%2FkZAnP0D4ovbCE%3D; bscookie=\"v=1&201710182204274d4e5ca5-94af-4eb2-81fa-155baa1207cdAQGQG4auWTnkvce351iyarVfxWkAiPGw\"'
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

        if h["meta"]["total"]==1
          p f.id
          f.linkedin_recruiter_url="https://www.linkedin.com/recruiter/profile/"+h["result"]["searchResults"][0]["findAuthInputModel"]["asUrlParam"] rescue " "
        end
        f.is_run=true
        f.save
        sleep 60

      rescue => ex
        print 'Error while processing'+ex.message
      end

    end
  rescue => ex
    print 'Error while executing query'+ex.message
  end

end