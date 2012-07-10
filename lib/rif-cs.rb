require 'rif-cs/party'
require 'rif-cs/service'
require 'rif-cs/collection'
require 'rif-cs/activity'

module RIFCS

  def self.camelize(lower_case_and_underscored_word)
    lower_case_and_underscored_word.to_s.gsub(/(?:_)(.)/) { $1.upcase }
  end

  def self.list_of(list, name, xml)
    #method_name = "#{prefix}_#{name}"
    #return unless respond_to?(method_name.to_sym)
#puts list.inspect
    list.each do |attrs|
      xml.send(camelize(name), attrs[:value], attrs.select{|k| k != :value})
    end
  end

  def self.names(list, xml)
    return if list.nil? or list.empty?
    list.each do |name|
      xml.name_(:dateFrom => name[:date_from], :dateTo => name[:date_to], :type => name[:type], 'xml:lang' => name[:xmllang]) do
        name[:name_parts].each do |part|
          xml.namePart_(part[:value], :type => part[:type])
        end
      end
    end
  end

  def self.locations(list, xml)
    return if list.nil? or list.empty?
    list.each do |location|
      xml.location_(:dateFrom => location[:date_from], :dateTo => location[:date_to], :type => location[:type]) do
        addresses(location[:addresses], xml)
        spatials(location[:spatials], xml)
      end
    end
  end

  def self.addresses(addr_list, xml)
    return if addr_list.nil? or addr_list.empty?
    xml.address_ do
      addr_list.each do |addr|
        electronic_addresses(addr[:electronic], xml)
        physical_addresses(addr[:physical], xml)
      end
    end
  end

  def self.electronic_addresses(addr_list, xml)
    return if addr_list.nil? or addr_list.empty?
    addr_list.each do |addr|
      xml.electronic_(:type => addr[:type]) do
        xml.value_ addr[:value]
        if addr.has_key?(:args)
          addr[:args].each do |arg|
            xml.arg_(arg[:value], :required => arg[:required], :type => arg[:type], :use => arg[:use])
          end
        end
      end
    end
  end

  def self.physical_addresses(addr_list, xml)
    return if addr_list.nil? or addr_list.empty?
    addr_list.each do |addr|
      xml.physical_(:type => addr[:type], 'xml:lang' => addr[:xmllang]) do
        addr[:address_parts].each do |addr_part|
          xml.addressPart_(addr_part[:value], :type => addr_part[:type])
        end
      end
    end
  end

  def self.coverage(list, xml)
    return if list.nil? or list.empty?
    list.each do |coverage|
      xml.coverage_ do
        spatials(coverage[:spatials], xml)
        temporals(coverage[:temporals], xml)
      end
    end
  end

  def self.spatials(spatial_list, xml)
    return if spatial_list.nil? or spatial_list.empty?
    spatial_list.each do |addr|
      xml.spatial_(addr[:value], :type => addr[:type], 'xml:lang' => addr[:xmllang])
    end
  end

  def self.temporals(temp_list, xml)
    return if temp_list.nil? or temp_list.empty?
    temp_list.each do |temp|
      xml.temporal_ do
        temp[:dates].each do |date_elem|
          xml.date_(date_elem[:value], :dateFormat => date_elem[:date_format], :type => date_elem[:type])
        end
        temp[:text].each do |text|
          xml.text_ text
        end
      end
    end
  end

  def self.related_objects(obj, xml)
    return if obj.nil?
    obj.each do |rel_type, relations|
      relations.each do |rel|
        xml.relatedObject do
          xml.key(rel[:key])
          xml.relation_(:type => camelize(rel_type)) do
            rel[:relation].each do |key, value|
              xml.send(key, value)
            end if rel.has_key?(:relation)
          end
        end
      end
    end
  end

  def self.related_info(list, xml)
    return if list.nil? or list.empty?
    list.each do |info|
      xml.relatedInfo_(:type => info[:type]) do
        xml.identifier_(info[:identifier][:value], :type => info[:identifier][:type])
        xml.title_(info[:title]) if info.has_key?(:title)
        xml.notes(info[:notes]) if info.has_key?(:notes)
      end
    end 
  end

  def self.rights(list, xml)
    return if list.nil? or list.empty?
    list.each do |rights|
      xml.rights_ do
        xml.rightsStatement_(rights[:rights_statement][:value], :rightsUri => rights[:rights_statement][:rights_uri]) if rights.has_key?(:rights_statement)
        xml.licence_(rights[:licence][:value], :rightsUri => rights[:licence][:rights_uri]) if rights.has_key?(:licence)
        xml.accessRights_(rights[:access_rights][:value], :rightsUri => rights[:access_rights][:rights_uri]) if rights.has_key?(:access_rights)
      end
    end
  end

  def self.subjects(list, xml)
    return if list.nil? or list.empty?
    list.each do |subject|
      xml.subject_(subject[:value], :termIdentifier => subject[:term_identifier], :type => subject[:type], 'xml:lang' => subject[:xmllang])
    end
  end

  def self.existence_dates(list, xml)
    return if list.nil? or list.empty?
    list.each do |dates|
      xml.existenceDates_ do
        [:start_date, :end_date].each do |datetype|
          date_obj = dates[datetype]
          next if date_obj.nil?
          xml.send(camelize(datetype), date_obj[:value], :dateFormat => date_obj[:date_format])
        end
      end
    end
  end

  def to_rif(encoding='UTF-8')
    reg_obj = to_registry_node
    doc = Nokogiri::XML::Document.new
    doc.encoding = encoding
    container = Nokogiri::XML::Node.new('registryObjects', doc)
    container['xsi:schemaLocation'] = 'http://ands.org.au/standards/rif-cs/registryObjects http://services.ands.org.au/documentation/rifcs/1.3/schema/registryObjects.xsd'
    doc.root = container
    reg_elems = reg_obj.doc.root.dup
    container.add_child(reg_elems)
    doc.root.to_xml
  end

end

