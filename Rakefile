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
