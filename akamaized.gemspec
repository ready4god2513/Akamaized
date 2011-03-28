# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "akamaized/version"

Gem::Specification.new do |s|
  s.name        = "akamaized"
  s.version     = Akamaized::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Brandon Hansen, Eric Casequin"]
  s.email       = ["brandon@morethanaprogrammer.com"]
  s.homepage    = "https://github.com/ready4god2513/Akamaized"
  s.summary     = %q{Manage data and files on Akamai's CDN}
  s.description = %q{Manage data and files on Akamai's CDN}

  s.rubyforge_project = "akamaized"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
