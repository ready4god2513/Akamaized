module Akamaized
  
  module AkamaizedException
    
    def delete_error(file)
      "unable to delete the file at #{file}"
    end
    
    def put_error(file)
      "unable to push file at #{file}"
    end
    
    def connection_error
      "unable to connect to Akamai.  Please check your authentication credentials"
    end
    
  end
  
end