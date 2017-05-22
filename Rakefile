require 'rubygems'
require 'rake'
require 'rake/rdoctask'


Rake::RDocTask.new('doc') do |rd|
  rd.rdoc_files.include("enhanced_marc/**/*.rb")
  rd.main = 'MARC::Record'
  rd.rdoc_dir = 'doc'
end
