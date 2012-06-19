require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rake/testtask'

task :default  => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "HasUrl"
  rdoc.main = 'README.rdoc'
  rdoc.rdoc_files.include('README*', 'LICENSE')
  rdoc.rdoc_files.include('lib/**/*.rb')
  rdoc.options << '--line-numbers'
  rdoc.options << '--charset=UTF-8'
end

desc 'Test the paperclip plugin.'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = true
end
