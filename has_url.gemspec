# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "has_url/version"

Gem::Specification.new do |s|
  s.name        = "has_url"
  s.version     = HasUrl::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Pickabee"]
  s.email       = [""]
  s.homepage    = "https://github.com/skateinmars/has_url"
  s.summary     = %q{Validation on URL attributes for ActiveRecord models}
  s.description = <<-EOL
  Adds validations on URL attributes for ActiveRecord models.
  URL scheme will be checked and added before updating the database if necessary.
  A raw_attribute method will also be added to display the url without HTTP(S) scheme or trailing slash.
  EOL

  s.add_dependency "activerecord", '>= 3.0.0'
  s.add_dependency "addressable", '>= 2.2.0'

  s.add_development_dependency "rake"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "shoulda", '>= 3.0.0'

  s.files = Dir["LICENSE", "README.rdoc", "Gemfile", "Rakefile", "has_url.gemspec", "{lib}/**/*.rb"]
  s.test_files = Dir["{spec}/**/*.rb"]
  s.rdoc_options = ["--line-numbers", "--charset=UTF-8", "--title", "HasUrl", "--main", "README.rdoc"]
  s.extra_rdoc_files = %w[LICENSE]
  s.require_paths = ["lib"]
end
