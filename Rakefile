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
    gem.summary = %Q{library to access google adwords api}
    gem.description = %Q{ruby library to access google adwords api}
    gem.email = "giovanni.ferro@gmail.com"
    gem.homepage = "http://github.com/sem4r/sem4r"
    gem.authors = ["Sem4r"]
    gem.add_dependency 'patron'
    gem.add_development_dependency "spec"

    #
    # files
    #
    gem.files  = %w{LICENSE README.rdoc Rakefile VERSION sem4r.gemspec}
    gem.files << 'config/sem4r.example.yml'
    # gem.files.concat Dir['examples/**/*.rb']
    gem.files.concat Dir['examples/*.rb']
    gem.files.concat Dir['lib/**/*.rb']

    gem.test_files = [] # Dir['test/**/*.rb']
    # concat all test files
    # gem.files.concat Dir['test_data/**/*']
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

#
# examples
#

namespace :sem4r do
  desc 'run all example'
  task :examples do
    %w{create.rb list_ad.rb list_keywords.rb}.each do |example|
      puts "---------------------------------------------------------------------"
      puts "Running #{example}"
      puts "---------------------------------------------------------------------"
      system "ruby examples/#{example}"
    end
  end
end
