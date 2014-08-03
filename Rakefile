# encoding: utf-8
require 'simplecov'
SimpleCov.start do
  add_filter 'test/'
end

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

$:.unshift File.dirname(__FILE__)

require 'lib/version'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "abbey"
  gem.homepage = "http://github.com/PJK/abbey"
  gem.license = "MIT"
  gem.summary = "Primitive JSON data store"
  gem.description = %Q{Primitive JSON data store. Key-value structure with namespaces.}
  gem.email = "me@pavelkalvoda.com"
  gem.authors = ["Pavel Kalvoda"]
  gem.version = Abbey::Version::STRING
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

task :test do
  require 'test/entity_storage_test'
end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "abbey #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
