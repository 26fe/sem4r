require 'rubygems'
require 'rake'

#
# jeweler
#
begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
    gem.name = "sem4r"
    gem.summary = %Q{Library to access google adwords api. Works with ruby 1.9 and ruby 1.8}
    gem.description = %Q{Library to access google adwords api. Works with ruby 1.9 and ruby 1.8.
                         This is a ALPHA version don't use in production}
    gem.email = "sem4ruby@gmail.com"
    gem.homepage = "http://www.sem4r.com"
    gem.authors = ["Sem4r"]
    # gem.add_dependency 'patron'
    gem.add_development_dependency "spec"

    #
    # files
    #
    gem.files  = %w{LICENSE README.rdoc Rakefile VERSION.yml sem4r.gemspec}
    gem.files << 'config/sem4r.example.yml'
    # gem.files.concat Dir['examples/**/*.rb']
    gem.files.concat Dir['examples/*.rb']
    gem.files.concat Dir['lib/**/*.rb']

    gem.test_files = Dir['spec/**/*.rb']
    # concat all test files
    gem.files.concat Dir['spec/fixtures/**/*']
    # gem.files.concat Dir['test_data/**/.dir_with_dot/*']

    #
    # rubyforge
    #
    gem.rubyforge_project = 'sem'
  end

  Jeweler::RubyforgeTasks.new do |rubyforge|
    rubyforge.doc_task = "rdoc"
  end

  Jeweler::GemcutterTasks.new
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
  rdoc.title = "sem4r #{version}"
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

###############################################################################
# Sem4r

namespace :sem4r do
  #
  # examples
  #
  desc 'run all example'
  task :examples do

    Dir['examples/*.rb'].sort.each do |filename|
      next unless filename =~ /\d\d.+\.rb$/
      unless system "ruby #{filename}"
        exit
      end
    end
    puts "All examples run successfull"

  end

  desc "Start an IRB shell"
  task :shell do
    sh 'IRBRC=`pwd`/config/irbrc.rb irb'
  end
end
