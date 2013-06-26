# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name        = 'master_key'
  s.version     = '0.0.0'
  s.date        = '2013-01-23'
  s.summary     = "Authentication module"
  s.description = "Master-key contains methods that help the application to get the user credentials and store them on the machine."
  s.authors     = ["Sapana Bilguche"]
  s.files       = ["lib/master_key.rb"]
  s.email       	=  	["sapana_bilguche@test.com"]
  s.homepage    	=  	"https://github.com/test/master_key"
  s.add_runtime_dependency(%q<highline>, ["~> 1.6.14"])
  s.add_runtime_dependency(%q<encrypted_strings>, ["~> 0.3.3"])
  s.add_runtime_dependency(%q<json>, ["~> 1.5.4"])
  s.add_runtime_dependency(%q<net-ssh>, ["~> 2.2.2"])
  s.add_runtime_dependency(%q<ruby-oci8>, ["~> 2.0.6"])
end
