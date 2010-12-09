require 'rubygems'
require 'rake'

# Load tasks
Dir.glob('tasks/**/*.rake').each { |r| Rake.application.add_import r }

task :test => :check_dependencies
task :default => :spec

