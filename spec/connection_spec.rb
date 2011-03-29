require "spec_helper"
require "yaml"

# This test requires the following files/directories
# config/akamai.yml
# config/test-file.txt
# config/downloads/

describe Akamaized do
  
  before(:each) do
    @config = YAML::load(File.open(File.expand_path("../../config/akamai.yml", __FILE__)))
    
  end
  
  it "should not connect without valid credentials" do
    expect {Akamaized::Connection.new}.to raise_error(Akamaized::Exception::ConnectionError)
  end
  
  it "should connect with valid credentials" do
    expect {Akamaized::Connection.new(@config)}.to_not raise_error
  end
  
  it "should not allow changing directories to directories that do not exist" do
    @config["base_dir"] = "this/directory/does/not/exist"
    expect {Akamaized::Connection.new(@config)}.to raise_error(Akamaized::Exception::ConnectionError)
  end
  
  it "should not be able to find a file that does not exist" do
    connection = Akamaized::Connection.new(@config)
    connection.exists?("a-file-that-does-not-exist.no-file").should == false
  end
  
  it "should put the file up on the server" do
    connection = Akamaized::Connection.new(@config)
    connection.delete("test-file.txt")
    connection.exists?("test-file.txt").should == false
    connection.put(File.expand_path("../../config/test-file.txt", __FILE__))
    connection.exists?("test-file.txt").should == true
    connection.get("test-file.txt", File.expand_path("../../config/downloads/", __FILE__))
    File.exists?(File.expand_path("../../config/downloads/test-file.txt", __FILE__))
    
    IO.read(File.expand_path("../../config/downloads/test-file.txt", __FILE__)).should == IO.read(File.expand_path("../../config//test-file.txt", __FILE__))
    connection.delete("test-file.txt")
    connection.exists?("test-file.txt").should == false
  end
  
end