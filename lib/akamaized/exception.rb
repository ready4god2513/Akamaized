module Akamaized
  
  module Exception
    
    class DeleteError < StandardError
      def initialize(file)
        @file = file
      end
      
      def message
        "unable to delete the file at #{@file}"
      end
    end
    
    class PutError < StandardError
      def initialize(file)
        @file = file
      end
      
      def message
        "unable to push file at #{file}"
      end
    end
    
    class ConnectionError < StandardError
      def initialize(message)
        @message = message
      end
      
      def message
        "Unable to connect to Akamai.  Please check your authentication credentials and internet cable.  Message: #{@message}"
      end
    end
    
  end
  
end