require 'rif-cs/party'
require 'rif-cs/service'
require 'rif-cs/collection'
require 'rif-cs/activity'


module RIFCS

  RIFCS_DEFAULT_LANG = 'en'

  def self.camelize(lower_case_and_underscored_word)
    lower_case_and_underscored_word.to_s.gsub(/(?:_)(.)/) { $1.upcase }
  end

  def self.list_of(list, name, xml)
    #method_name = "#{prefix}_#{name}"
    #return unless respond_to?(method_name.to_sym)
    #puts list.inspect
    list.each do |attrs|
      xml.send(camelize(name), attrs[:value], Hash[attrs.select{|k,v|  k != :value}])
    end
  end

  def self.names(list, xml)
    return if list.nil? or list.empty?
    list.each do |name|

      # The attributes dateFrom and dateTo are optional,
      # so we will put them to name element only when
      # the string values are not empty and valid.
      attributes = {}
      if !name[:date_from].nil? and !name[:date_from].blank?
        attributes[:dateFrom] = name[:date_from]
      end

      if !name[:date_to].nil? and !name[:date_to].blank?
        attributes[:dateTo] = name[:date_to]
      end

      attributes[:type] = name[:type]
      attributes['xml:lang'] = getLang(name)

     xml.name_(attributes) do
        name[:name_parts].each do |part|
          # we will include the type attribute only if it specified
          if part[:type].nil?
            xml.namePart_(part[:value]) unless part[:value].blank?
          else
            xml.namePart_(part[:value], :type => part[:type]) unless part[:value].blank?
          end
        end
      end
    end
  end

  def self.locations(list, xml)
    return if list.nil? or list.empty?
    list.each do |location|

      # The attributes dateFrom and dateTo are optional,
      # so we will put them to location element only when
      # the string values are not empty and valid.
      attributes = {}
      if !location[:date_from].nil? and !location[:date_from].blank?
        attributes[:dateFrom] = location[:date_from]
      end

      if !location[:date_to].nil? and !location[:date_to].blank?
        attributes[:dateTo] = location[:date_to]
      end

      attributes[:type] = location[:type]
      xml.location_(attributes) do
        addresses(location[:addresses], xml)
        spatials(location[:spatials], xml)
      end
    end
  end

  def self.addresses(addr_list, xml)
    return if addr_list.nil? or addr_list.empty? or (!has_electronic_addresses(addr_list) and !has_physical_addresses(addr_list))

    xml.address_ do
      addr_list.each do |addr|
        electronic_addresses(addr[:electronic], xml)
        physical_addresses(addr[:physical], xml)
      end
    end
  end

  def self.has_electronic_addresses(addr_list)
    return false if addr_list.nil? or addr_list.empty?  or (addr_list.size == 1 &&  addr_list[0][:electronic][0][:value].blank? )
    true
  end

  def self.has_physical_addresses(addr_list)
    return false if addr_list.nil? or addr_list.empty? or (addr_list.size == 1 &&  addr_list[0][:physical][0][:value].blank? )
    true
  end

  def self.electronic_addresses(addr_list, xml)
    return if addr_list.nil? or addr_list.empty?  or (addr_list.size == 1 &&  addr_list[0][:value].blank? )
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
    return if addr_list.nil? or addr_list.empty? or (addr_list.size == 1 &&  addr_list[0][:address_parts][0][:value].blank? )
    addr_list.each do |addr|
      xml.physical_(:type => addr[:type], 'xml:lang' => getLang(addr) ) do
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

  def self.has_spatials(spatial_list)
    return false if spatial_list.nil? or spatial_list.empty?
    true
  end

  def self.spatials(spatial_list, xml)
    return if spatial_list.nil? or spatial_list.empty?
    spatial_list.each do |addr|
      xml.spatial_(addr[:value], :type => addr[:type], 'xml:lang' => getLang(addr))
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
    if obj.is_a?(Array)
      related_objects_array(obj,xml)
    else
      related_object_map(obj, xml)
    end
  end

  def self.related_object_map(obj, xml)
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

  def self.related_objects_array(obj, xml)
    return if obj.nil?
    obj.each do |relation|
      rel = relation[:values]
      xml.relatedObject do
        xml.key(rel[:key])
        xml.relation_(:type => camelize(relation[:name])) do
          rel[:relation].each do |key, value|
            xml.send(key, value)
          end if rel.has_key?(:relation)
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
      xml.subject_(subject[:value], :termIdentifier => subject[:term_identifier], :type => subject[:type], 'xml:lang' => getLang(subject))
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

  def self.getLang(hash)
    if hash[:xmllang]
      hash[:xmllang]
    else
      RIFCS_DEFAULT_LANG
    end
  end

  def to_rif(encoding='UTF-8')
    reg_obj = to_registry_node
    doc = Nokogiri::XML::Document.new
    doc.encoding = encoding
    container = Nokogiri::XML::Node.new('registryObjects', doc)
    container['xmlns'] = "http://ands.org.au/standards/rif-cs/registryObjects"
    container['xmlns:xsi'] = "http://www.w3.org/2001/XMLSchema-instance"
    container['xsi:schemaLocation'] = 'http://ands.org.au/standards/rif-cs/registryObjects http://services.ands.org.au/documentation/rifcs/1.3/schema/registryObjects.xsd'
    doc.root = container
    reg_elems = reg_obj.doc.root.dup
    container.add_child(reg_elems)
    doc.root.to_xml
  end

end

