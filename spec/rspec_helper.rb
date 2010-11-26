$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'sem4r'
require 'sem4r_cli'
include Sem4r

require 'sem4r_rspec_helper'
require 'rspec_matchers'
require 'sem4r_stubs'
require 'aggregates_rspec_helper'

# Spec::Runner.configure do |config|
# end
