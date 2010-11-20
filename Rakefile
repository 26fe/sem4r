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
       Sem4r is a library to access google adwords api.
       It will works with ruby 1.9 and ruby 1.8 without soap4r.
       It uses a high level model instead of a low level api.
       You think about clients, campaigns, keywords and not about operations, operands, selectors, service calls.

       This is a ALPHA version don't use in production.
       If you are interested in this project let me now: install it and update periodically, so the gemcutter
       download counter go up. Or subscribe to my feed at sem4r.com. Or watch the project on github.
       Or simply drop me a line in email. However I will know there is someone out of here.
    }

    gem.authors = ["Sem4r"]
    gem.email = "sem4ruby@gmail.com"
    gem.homepage = "http://www.sem4r.com"

    #
    # dependecies
    #
    # gem.add_dependency 'patron'
    gem.add_dependency 'builder'
    gem.add_development_dependency 'rspec'
    gem.add_development_dependency 'differ'

    #
    # files
    #
    gem.files  = %w{LICENSE README.rdoc Rakefile VERSION.yml sem4r.gemspec}
    gem.files << 'config/sem4r.example.yml'
    gem.files.concat Dir['examples_sem4r/*.rb']
    gem.files.concat Dir['examples_blog/*.rb']
    gem.files.concat Dir['lib/**/*.rb']

    #
    # test files
    #
    gem.test_files = Dir['spec/**/*.rb']
    gem.test_files.concat Dir['spec/fixtures/**/*']

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

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

#RSpec::Core::RakeTask.new(:core) do |spec|
#  spec.pattern = 'spec/**/*_spec.rb'
#  spec.rspec_opts = ['--backtrace']
#end
#
#
#desc "Generate HTML report for failing examples"
#RSpec::Core::RakeTask.new('failing_examples_with_html') do |spec|
#  spec.pattern = 'failing_examples/**/*.rb'
#  spec.rspec_opts = ["--format", "html:doc/reports/tools/failing_examples.html", "--diff"]
#  spec.fail_on_error = false
#end

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
