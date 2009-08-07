RUBY_ENHANCED_MARC_VERSION = '0.1'

Gem::Specification.new do |s|
  s.add_dependency('marc')
  s.name = 'enhanced_marc'
  s.version = RUBY_ENHANCED_MARC_VERSION
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.date = %q{2009-08-07}
  s.author = 'Ross Singer'
  s.email = 'rossfsinger@gmail.com'
  s.homepage = 'http://github.com/rsinger/enhanced-marc/tree'
  s.platform = Gem::Platform::RUBY
  s.summary = 'A set of enhancements to ruby-marc to make parsing MARC data easier'
  s.description = 'A set of enhancements to ruby-marc to make parsing MARC data easier'
  s.files = Dir.glob("{lib,test}/**/*") + ["Rakefile", "README", "Changes",
    "LICENSE"]
  s.require_path = 'enhanced_marc'
  s.has_rdoc = true
  s.required_ruby_version = '>= 1.8.6'
  
  s.test_file = 'test/ts_enhanced_marc.rb'
  s.bindir = 'bin'
end
