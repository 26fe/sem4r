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
    gem.description = %Q{
       Library to access google adwords api.
       The idea is to use a high level model instead of a low level api.
       You think about clients, campaigns, keywords and not about operations, operands, service calls.
       The library could decide which api use (sync or async) and when call it!
       It will works with ruby 1.9 and ruby 1.8 without soap4r.

       This is a ALPHA version don't use in production.
       If you want experiment you are welcome, but the first usable version will be the 0.1.0.
       I don't kwnow when I will release it.
       If you are interested in this project let me now: install it and update periodically, so the gemcutter
       download counter go up. Or subscribe to my feed at sem4r.com. Or watch the project on github.
       Or simply drop me a line in email. However I will know there is someone out of here.
       Thank you for reading.
    }
    gem.email = "sem4ruby@gmail.com"
    gem.homepage = "http://www.sem4r.com"
    gem.authors = ["Sem4r"]
    # gem.add_dependency 'patron'
    gem.add_dependency 'builder'
    gem.add_development_dependency "rspec"
    gem.add_development_dependency "differ"

    #
    # files
    #
    gem.files  = %w{LICENSE README.rdoc Rakefile VERSION.yml sem4r.gemspec}
    gem.files << 'config/sem4r.example.yml'
    # gem.files.concat Dir['examples/**/*.rb']
    gem.files.concat Dir['examples/*.rb']
    gem.files.concat Dir['examples_blog/*.rb']
    gem.files.concat Dir['lib/**/*.rb']

    gem.test_files = Dir['spec/**/*.rb']
    # concat all test files
    gem.files.concat Dir['spec/fixtures/**/*']
    # gem.files.concat Dir['test_data/**/.dir_with_dot/*']

    #
    # rubyforge
    #
    # gem.rubyforge_project = 'sem'
  end

  # Jeweler::RubyforgeTasks.new do |rubyforge|
  #   rubyforge.doc_task = "rdoc"
  # end

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
  desc 'run all sem4r example'
  task :examples do

    Dir['examples_sem4r/*.rb'].sort.each do |filename|
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
