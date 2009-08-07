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

spec = Gem::Specification.new do |s|
  s.name = 'enhanced_marc'
  s.version = RUBY_ENHANCED_MARC_VERSION
  s.author = 'Ross Singer'
  s.email = 'rossfsinger@gmail.com'
  s.homepage = 'http://github.com/rsinger/enhanced-marc/tree'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A set of enhancements to ruby-marc to make parsing MARC data easier'
  s.files = Dir.glob("{lib,test}/**/*") + ["Rakefile", "README", "Changes",
    "LICENSE"]
  s.require_path = 'enhanced_marc'
  s.autorequire = 'marc'
  s.has_rdoc = true
  s.required_ruby_version = '>= 1.8.6'
  
  s.test_file = 'test/ts_enhanced_marc.rb'
  s.bindir = 'bin'
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_zip = true
  pkg.need_tar = true
end

Rake::RDocTask.new('doc') do |rd|
  rd.rdoc_files.include("enhanced_marc/**/*.rb")
  rd.main = 'MARC::Record'
  rd.rdoc_dir = 'doc'
end
