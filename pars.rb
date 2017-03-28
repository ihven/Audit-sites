    require 'rubygems'
	require 'net/http'
	require 'uri'
	require 'openssl'
	require 'mail'   
	
	
	def ssl_request(url)
	  
	  uri = URI.parse(url)
	  http = Net::HTTP.new(uri.host, uri.port)
	  http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

	  request = Net::HTTP::Get.new(uri.request_uri)
	  
	  
	  begin
		response = http.request(request) 	     
	  rescue
	     puts "There is no connection."
		 return  "0"
	  else
        return  response.code
      end		
	    
   end
	
	
def send_mes (status, site)
	
	options = { :address              => "smtp.gmail.com",
				:port                 => 587,
				:user_name            => "ivantestersites@gmail.com",
				:password             => "qwertQWERT",
				:authentication       => "plain",
				:enable_starttls_auto => true  }

	Mail.defaults do
	  delivery_method :smtp, options
	end

	if (status.to_i == 200)
		subj = "Status ok !"
	else
        subj = "Status error !"	
	end	
	
	Mail.deliver do
			 
			 to "alert@pokupon.ua" 
    		 from "ivantestersites@gmail.com"
		     subject "#{subj}"
			 body "Status:  #{status}   of   #{site}"
	end
end	

  status1 =  "200";
  status2 =  "200";
  
  loop do
  
	  status3 =  ssl_request("https://pokupon.ua/");
	  status4 =  ssl_request("https://partner.pokupon.ua/");
	 
	  
	  if((status3.to_i != 0)&&(status1 != status3)&&((status1.to_i == 200)||(status3.to_i == 200)))
		send_mes(status3, "https://pokupon.ua/");
	  end
	  
	  if((status4.to_i != 0)&&(status2 != status4)&&((status2.to_i == 200)||(status4.to_i == 200)))
		send_mes(status4, "https://partner.pokupon.ua/");
	  end
	  
	  status1 =  status3;
	  status2 =  status4;
      
	  sleep 60
end


	
	