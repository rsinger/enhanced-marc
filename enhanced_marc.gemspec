# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'enhanced_marc/version'
Gem::Specification.new do |s|
  s.name = %q{enhanced_marc}
  s.version = MARC::EnhancedMARC::VERSION

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ross Singer"]
  s.description = %q{A set of enhancements to ruby-marc to make parsing MARC data easier}
  s.email = %q{rossfsinger@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.md"
  ]
  s.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.homepage = %q{http://github.com/rsinger/enhanced-marc/tree}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{2.0.0}
  s.summary = %q{A DSL for MARC data}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<marc>, [">= 0"])
      s.add_runtime_dependency(%q<locale>, [">= 0"])
    else
      s.add_dependency(%q<marc>, [">= 0"])
      s.add_dependency(%q<locale>, [">= 0"])
    end
  else
    s.add_dependency(%q<marc>, [">= 0"])
    s.add_dependency(%q<locale>, [">= 0"])
  end
end

