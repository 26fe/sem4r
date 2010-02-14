$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'sem4r'
include Sem4r

require 'sem4r_spec_helper'



Spec::Runner.configure do |config|
#  config.use_transactional_fixtures = true
#  config.use_instantiated_fixtures  = false
#  config.fixture_path = RAILS_ROOT + '/spec/fixtures'
end


###
## rSpec Hash additions.
##
## From
##   * http://wincent.com/knowledge-base/Fixtures_considered_harmful%3F
##   * Neil Rahilly
#
#class Hash
#
#  ##
#  # Filter keys out of a Hash.
#  #
#  #   { :a => 1, :b => 2, :c => 3 }.except(:a)
#  #   => { :b => 2, :c => 3 }
#
#  def except(*keys)
#    self.reject { |k,v| keys.include?(k || k.to_sym) }
#  end
#
#  ##
#  # Override some keys.
#  #
#  #   { :a => 1, :b => 2, :c => 3 }.with(:a => 4)
#  #   => { :a => 4, :b => 2, :c => 3 }
#
#  def with(overrides = {})
#    self.merge overrides
#  end
#
#  ##
#  # Returns a Hash with only the pairs identified by +keys+.
#  #
#  #   { :a => 1, :b => 2, :c => 3 }.only(:a)
#  #   => { :a => 1 }
#
#  def only(*keys)
#    self.reject { |k,v| !keys.include?(k || k.to_sym) }
#  end
#
#end

