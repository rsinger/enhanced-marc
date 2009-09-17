RUBY_ENHANCED_MARC_VERSION = '0.1'

require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/packagetask'
require 'rake/gempackagetask'

task :default => [:test]

Rake::TestTask.new('test') do |t|
  t.libs << 'lib'
  t.pattern = 'test/tc_*.rb'
  t.verbose = true
  t.ruby_opts = ['-r marc', '-r test/unit']
end

Rake::RDocTask.new('doc') do |rd|
  rd.rdoc_files.include("enhanced_marc/**/*.rb")
  rd.main = 'MARC::Record'
  rd.rdoc_dir = 'doc'
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |s|
    
    s.add_dependency('marc')
    s.name = 'enhanced_marc'
    s.author = 'Ross Singer'
    s.email = 'rossfsinger@gmail.com'
    s.homepage = 'http://github.com/rsinger/enhanced-marc/tree'
    s.summary = 'A DSL for MARC data'
    s.description = 'A set of enhancements to ruby-marc to make parsing MARC data easier'    
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

