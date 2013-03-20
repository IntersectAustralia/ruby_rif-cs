$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'rif-cs'
require 'example_models'

# replicating rails blank? method for spec tests
class Nil

  def blank?
    self.nil? || self.empty?
  end

end

class String

  def blank?
    self.nil? || self.empty?
  end

end

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  
end
