require 'rubygems'
require 'rake'

#
# jeweler
#
begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "sem4r"
    gem.summary = %Q{library to access google adwords api}
    gem.description = %Q{ruby library to access google adwords api}
    gem.email = "giovanni.ferro@gmail.com"
    gem.homepage = "http://github.com/sem4r/sem4r"
    gem.authors = ["Sem4r"]
    # gem.add_development_dependency "thoughtbot-shoulda", ">= 0"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

#
# rdoc
#
require 'rake/rdoctask'

Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "the-perferct-gem #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

#
# spec
#

require 'spec/rake/spectask'

desc "Run all examples"
Spec::Rake::SpecTask.new('spec') do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
end

desc "Generate HTML report for failing examples"
Spec::Rake::SpecTask.new('failing_examples_with_html') do |t|
  t.spec_files = FileList['failing_examples/**/*.rb']
  t.spec_opts = ["--format", "html:doc/reports/tools/failing_examples.html", "--diff"]
  t.fail_on_error = false
end

task :test => :check_dependencies
task :default => :spec

desc 'rull all example'
task :examples do
  %w{create.rb list_ad.rb list_keywords.rb}.each do |example|
    puts "---------------------------------------------------------------------"
    puts "Running #{example}"
    puts "---------------------------------------------------------------------"
    system "ruby examples/#{example}"
  end  
end
