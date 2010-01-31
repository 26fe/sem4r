$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'sem4r'
include Sem4r

def load_response(service, call)
  fixture_dir  = File.join(File.dirname(__FILE__), "fixtures", "services")
  fixture_file = File.join(fixture_dir, service + "_" + call + ".xml")
  File.open(fixture_file).read
end
