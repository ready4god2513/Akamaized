require "tempfile"
require "net/ftp"

module Akamaized
  
  class Config
    attr_accessor :username, :password, :host, :base_dir
    
    def initialize(opts = {})
      opts = {
        :username => "",
        :password => "",
        :host => "",
        :base_dir => ""
      }.merge(opts)
      
      self.username = opts[:username]
      self.password = opts[:password]
      self.host = opts[:host]
      self.base_dir = opts[:base_dir]
    end
    
  end
  
  class Connection
    
    include Exception
    
    def initialize(config = {})
      @config = Config.new(config)
      create_connection
    end
    
    
    def create_connection
      begin
        @connection = Net::FTP.new(@config.host)
        @connection.passive = true
        @connection.login(@config.username, @config.password)
        @connection.chdir(@config.base_dir) unless @config.base_dir.blank?
      rescue IOError, SystemCallError, Net::FTPError => e
        raise ConnectionError.new(e.message)
      end
    end
    
    
    # Check to see if a file 
    def exists?(file, location = nil)
      begin
        @connection.chdir(location) unless location.nil?
        !@connection.nlst(file).empty?
      rescue Net::FTPPermError => e
        return false if e.message.include?("not exist")
        raise
      end
    end
    
    
    # Take a local file and push it up to akamai
    # Will raise an exception if unable to push the file up
    # or the file is empty after upload (0 bytes)
    def put(file, location = nil)
      @connection.chdir(location) unless location.nil?
      @connection.put(file, File.basename(file))
    end
    
    
    # Get a file off of the server
    def get(remote, local, location = nil)
      @connection.chdir(location) unless location.nil?
      @connection.get(remote, "#{local}/#{File.basename(remote)}")
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
      raise DeleteError.new(file) unless delete(file, location)
    end
    
  end
  
end