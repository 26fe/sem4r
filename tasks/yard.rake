require 'yard'

YARD::Rake::YardocTask.new do |t|
  t.files   = ['lib/**/*.rb']
  t.options = [
      '--readme', 'README.rdoc',
      # '--output-dir', 'doc/yardoc'
      '--any',
      '--extra',
      '--opts'
  ]
end


#
# rdoc
#

#require 'rake/rdoctask'
#
#Rake::RDocTask.new do |rdoc|
#  version = File.exist?('VERSION') ? File.read('VERSION') : ""
#  rdoc.rdoc_dir = 'rdoc'
#  rdoc.title = "sem4r #{version}"
#  rdoc.rdoc_files.include('README*')
#  rdoc.rdoc_files.include('lib/**/*.rb')
#end
