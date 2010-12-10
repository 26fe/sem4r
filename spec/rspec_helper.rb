# -*- coding: utf-8 -*-
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'sem4r'
require 'sem4r_cli'
include Sem4r

require 'helpers/rspec_sem4r_helper'
require 'helpers/rspec_matchers'
require 'helpers/sem4r_stubs'
require 'helpers/aggregates_rspec_helper'

# Spec::Runner.configure do |config|
# end
