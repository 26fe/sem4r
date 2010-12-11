#
# spec
#
begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)

  RSpec::Core::RakeTask.new do |t|
    t.rspec_opts = ["--color", "--format", "spec", '--backtrace']
    t.pattern    = 'spec/**/*_spec.rb'
  end

#desc "Generate HTML report for failing examples"
#RSpec::Core::RakeTask.new('failing_examples_with_html') do |spec|
#  spec.pattern = 'failing_examples/**/*.rb'
#  spec.rspec_opts = ["--format", "html:doc/reports/tools/failing_examples.html", "--diff"]
#  spec.fail_on_error = false
#end
rescue LoadError
  puts "rspec (or a dependency) not available. Install it with: sudo gem install jeweler"
end
