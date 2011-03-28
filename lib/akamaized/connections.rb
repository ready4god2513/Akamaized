require "tempfile"
require "net/ftp"

module Akamaized
  
  class Config
    attr_accessor :username, :password, :host, :base_dir
    
    def initialize(opts = {})
      opts = {
        username: nil,
        password: nil,
        host: nil,
        base_dir: nil
      }.merge(opts)
      
      self.username = opts["username"]
      self.password = opts["password"]
      self.host = opts["host"]
      self.base_dir = opts["base_dir"]
    end
    
  end
  
  class Connection
    
    include AkamaizedException
    
    def initialize(config = {})
      Config.new(config)
      create_connection
    end
    
    
    def create_connection
      begin
        @connection = Net::FTP.new(Config.host)
        @connection.passive = true
        @connection.login(Config.username, Config.password)
        @connection.chdir(Config.base_dir) if Config.base_dir
      rescue Exception => e
        raise connection_error
      end
    end
    
    
    # Check to see if a file 
    def exists?(file, location = nil)
      @connection.chdir(location) unless location.nil?
      !@connection.nlist(file).empty?
    end
    
    
    # Take a local file and push it up to akamai
    # Will raise an exception if unable to push the file up
    # or the file is empty after upload (0 bytes)
    def put(file, location = nil)
      Tempfile.open(file) do |temp|
        temp.write(yield)
        temp.flush
        
        @connection.chdir(location) unless location.nil?
        
        @connection.put(temp.path, "#{file}.new")
        @connection.rename("#{file}.new", file)
        
        raise put_error(file) if !exists?(file, location)
      end
    end
    
    
    # Will attempt to login to the server an remove a file.  Returns
    # false if unable to delete the file
    def delete(file, location = nil)
      begin
        @connection.chdir(location) unless location.nil?
        @connection.delete(file)
      rescue Exception => e
        false
      end
    end
    
    
    # Calls the delete method, however, will raise an exception if there was an issue
    # whereas "delete" itself will swallow all errors
    def delete!(file, location = nil)
      raise delete_error(file) unless delete(file, location)
    end
    
  end
  
end