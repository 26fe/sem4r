$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'sem4r'
require 'sem4r_cli'
include Sem4r

require 'sem4r_spec_helper'
require 'aggregates_spec_helper'

Spec::Runner.configure do |config|
#  config.use_transactional_fixtures = true
#  config.use_instantiated_fixtures  = false
#  config.fixture_path = RAILS_ROOT + '/spec/fixtures'
end

