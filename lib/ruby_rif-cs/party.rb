module RIFCS
  module Party
    require 'nokogiri'

    def to_rifcs(encoding='UTF-8')
      Nokogiri::XML::Builder.new(:encoding => encoding) do |xml|
        xml.registryObject_(:group => party_group) do

          xml.key_ party_key

          xml.originatingSource_ party_originating_source if respond_to?(:party_originating_source)

          xml.party_(:dateModified => party_date_modified, :type => party_type) do
            list_of(:identifier, xml)

            if respond_to?(:party_names)
              party_names.each do |name|
                xml.name_(:type => name[:type], :dateFrom => name[:datefrom], :dateTo => name[:dateto], 'xml:lang' => name[:xmllang]) do
                  name[:nameparts].each do |name_type, value|
                    xml.namePart_(value, :type => name_type)
                  end
                end
              end
            end

            if respond_to?(:party_locations)
              party_locations.each do |location|
                xml.location_(:dateFrom => location[:datefrom], :dateTo => location[:dateto], :type => location[:type]) do
                  addresses(location[:addresses], xml)
                  spatials(location[:spatials], xml)
                end
              end
            end

            if respond_to?(:party_coverage)
              party_coverage.each do |coverage|
                xml.coverage_ do
                  spatials(coverage[:spatials], xml)
                  temporals(coverage[:temporals], xml)
                end
              end
            end

            list_of(:description, xml)

            if respond_to?(:party_existence_dates)
              party_existence_dates.each do |dates|
                xml.existenceDates_ do
                  [:startDate, :endDate].each do |datetype|
                    date_obj = dates[datetype.downcase]
puts date_obj.inspect
                    next if date_obj.nil?
                    xml.send(datetype, date_obj[:value], :dateFormat => date_obj[:dateformat])
                  end
                end
              end
            end

            if respond_to?(:party_related_infos)
              party_related_infos.each do |info|
                xml.relatedInfo_(:type => info[:type]) do
                  xml.identifier_(info[:identifier][:value], :type => info[:identifier][:type])
                  xml.title_(info[:title]) if info.has_key?(:title)
                  xml.notes(info[:notes]) if info.has_key?(:notes)
                end
              end
            end

            if respond_to?(:party_related_objects)
              party_related_objects.each do |relation_type, relations|
                relations.each do |rel|
                  xml.relatedObject do
                    xml.key(rel[:key])
                    xml.relation_(:type => relation_type) do
                      rel[:relation].each do |key, value|
                        xml.send(key, value)
                      end if rel.has_key?(:relation)
                    end
                  end
                end
              end
            end # related objects

            if respond_to?(:party_rights)
              party_rights.each do |rights|
                xml.rights_ do
                  xml.rightsStatement_(rights[:rightsstatement][:value], :rightsUri => rights[:rightsstatement][:rightsuri]) if rights.has_key?(:rightsstatement)
                  xml.licence_(rights[:licence][:value], :rightsUri => rights[:licence][:rightsuri]) if rights.has_key?(:licence)
                  xml.accessRights_(rights[:accessrights][:value], :rightsUri => rights[:accessrights][:rightsuri]) if rights.has_key?(:accessrights)
                end
              end
            end

            if respond_to?(:party_subjects)
              party_subjects.each do |subject|
                xml.subject_(subject[:value], :termIdentifier => subject[:termidentifier], :type => subject[:type], 'xml:lang' => subject[:xmllang])
              end
            end

          end # party
        end
      end
    end

    def party_key
      raise "Supply a party_key attribute or implement a method"
    end

    def addresses(addr_list, xml)
      return if addr_list.nil? or addr_list.empty?
      xml.address_ do
        addr_list.each do |addr|
          electronic_addresses(addr[:electronic], xml)
          physical_addresses(addr[:physical], xml)
        end
      end
    end

    def electronic_addresses(addr_list, xml)
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

    def physical_addresses(addr_list, xml)
      return if addr_list.nil? or addr_list.empty?
      addr_list.each do |addr|
        xml.physical_(:type => addr[:type], 'xml:lang' => addr[:xmllang]) do
          addr[:addressparts].each do |addr_part|
            xml.addressPart_(addr_part[:value], :type => addr_part[:type])
          end
        end
      end
    end

    def spatials(spatial_list, xml)
      return if spatial_list.nil? or spatial_list.empty?
      spatial_list.each do |addr|
        xml.spatial_(addr[:value], :type => addr[:type], 'xml:lang' => addr[:xmllang])
      end
    end

    def temporals(temp_list, xml)
      return if temp_list.nil? or temp_list.empty?
      temp_list.each do |temp|
        xml.temporal_ do
          temp[:dates].each do |date_elem|
            xml.date_(date_elem[:value], :dateFormat => date_elem[:dateformat], :type => date_elem[:type])
          end
          temp[:text].each do |text|
            xml.text_ text
          end
        end
      end
    end

    def list_of(name, xml)
      method_name = "party_#{name}"
      return unless respond_to?(method_name.to_sym)
      send(method_name).each do |attrs|
        xml.send(name, attrs[:value], attrs.select{|k| k != :value})
      end
    end

=begin
        <party type="person">
        <identifier type="uri">http://www.scopus.com/authid/detail.url?authorId=16231437200</identifier>
        <identifier type="local">deakin.edu.au/dro/author/2073</identifier>
        <name type="primary">
            <namePart type="title">Dr</namePart>
            <namePart type="family">Morgan</namePart>
            <namePart type="given">Mark</namePart>
        </name>
        <location>
            <address>
            <electronic type="uri">
                <value>http://www.greaterhealth.org/about/staff/mark-morgan/</value>
            </electronic>
            <physical type="postalAddress">
                <addressPart type="text">Deakin University, Locked Bag 20000, Geelong, Victoria, 3220, Australia</addressPart>
            </physical>
            </address>
        </location>
        <subject type="anzsrc-for">111799</subject>
        <subject type="anzsrc-for">111714</subject>
    <relatedInfo type="website" >
            <identifier type="uri">http://dro.deakin.edu.au/list/author_id/2073</identifier>
            <title>Browse by AuthorID - Morgan, Mark</title>
            <notes>List of Mark Morgan&#39;s work in Deakin Research Online</notes>
    </relatedInfo>
        </party>
    </registryObject>
=end

  end
end
