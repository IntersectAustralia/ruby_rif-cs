require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

def tests(record_type)

  record = Object.const_get("#{record_type}Example").new

  it "should give a RIF-CS XML #{record_type} record for a model" do
    expected = Nokogiri::XML(IO.read(File.join(File.dirname(__FILE__), 'files', "#{record_type.downcase}.xml"))).children.children.first.next.to_xml.gsub(/^\s{2}/, '')
    record = Object.const_get("#{record_type}Example").new
    record.to_registry_node.doc.root.to_xml(:indent => 2).should eq(expected)
  end

  it "should give a #{record_type} record wrapped in a registryObjects tag" do
    expected = IO.read(File.join(File.dirname(__FILE__), 'files', "#{record_type.downcase}.xml"))
    record.to_rif.strip.should == expected.strip
  end
end

describe "RIFCS::Activity" do
  tests('Activity')
end

describe "RIFCS::Collection" do
  tests('Collection')
end

describe "RIFCS::Party" do
  tests('Party')
end

describe "RIFCS::Service" do
  tests('Service')
end
