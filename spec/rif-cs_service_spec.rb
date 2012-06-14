require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
describe "RIFCS::Service" do

  class ServiceExample
    include RIFCS::Service

    attr_reader :service_key, :service_group

    def initialize(key, group='Intersect Australia')
      @service_key = key || 'service key'
      @service_group = group
    end

    def service_originating_source
      'http://www.intersect.org.au'
    end

    def service_root
      {
        date_modified: Time.now.utc,
        type: 'create'
      }
    end

    def service_type
    end
  end

  it "should give a RIF-CS XML Service record for a model" do
    foo = ServiceExample.new(nil)
    puts foo.to_rifcs.to_xml
  end
end
