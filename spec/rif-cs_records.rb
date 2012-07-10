require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

def tests(record_type)

  record = Object.const_get("#{record_type}Example").new

  it "should give a RIF-CS XML #{record_type} record for a model" do
    expected = Nokogiri::XML(IO.read(File.join(File.dirname(__FILE__), 'files', "#{record_type.downcase}.xml"))).at_xpath('//registryObject').to_xml.gsub(/^\s{2}/, '')
    record = Object.const_get("#{record_type}Example").new
    record.to_registry_node.doc.root.to_xml(:indent => 2).should eq(expected)
  end

  it "should give a #{record_type} record wrapped in a registryObjects tag" do
    expected = IO.read(File.join(File.dirname(__FILE__), 'files', "#{record_type.downcase}.xml"))
    record.to_rif.should == expected
  end
end

%w{Activity Collection Party Service}.each do |record|
  describe "RIFCS::#{record}" do
    tests(record)
  end
end
