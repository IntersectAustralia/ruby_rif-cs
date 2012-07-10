module RIFCS
  module Collection
    include RIFCS
    require 'nokogiri'

    def to_registry_node(encoding='UTF-8')
      Nokogiri::XML::Builder.new(:encoding => encoding) do |xml|
        xml.registryObject_(:group => collection_group) do

          xml.key_ collection_key
          xml.originatingSource_ collection_originating_source if respond_to?(:collection_originating_source)

          xml.collection_(:dateModified => collection_date_modified, :type => collection_type, :dateAccessioned => collection_date_accessioned) do
            RIFCS::list_of(collection_identifiers, :identifiers, xml) if respond_to?(:collection_identifiers)

            RIFCS::names(collection_names, xml) if respond_to?(:collection_names)

            RIFCS::locations(collection_locations, xml) if respond_to?(:collection_locations)

            RIFCS::coverage(collection_coverage, xml) if respond_to?(:collection_coverage)

            RIFCS::related_objects(collection_related_objects, xml) if respond_to?(:collection_related_objects)

            RIFCS::subjects(collection_subjects, xml) if respond_to?(:collection_subjects)

            RIFCS::list_of(collection_descriptions, :descriptions, xml) if respond_to?(:collection_descriptions)

            RIFCS::rights(collection_rights, xml) if respond_to?(:collection_rights)

            RIFCS::related_info(collection_related_info, xml) if respond_to?(:collection_related_infos)

            citation_info(collection_citation_info, xml) if respond_to?(:collection_citation_info)
          end # collection
        end
      end
    end

    def citation_info(list, xml)
      return if list.nil? or list.empty?
      list.each do |citation|
        xml.fullCitation_(citation[:full_citation][:value], :style => citation[:full_citation][:style]) 
        xml.citationMetadata_ do
          meta_obj = citation[:citation_metadata]
          xml.identifier(meta_obj[:identifier][:value], :type => meta_obj[:identifier][:type])
          meta_obj[:contributor].each do |name|
            xml.contributor_(:seq => name[:seq]) do
              name[:name_parts].each do |part|
                xml.namePart_(part[:value], :type => part[:type])
              end
            end
          end
          xml.title_(meta_obj[:title])
          xml.edition_(meta_obj[:edition])
          xml.publisher_(meta_obj[:publisher]) if meta_obj.has_key?(:publisher)
          xml.placePublished_(meta_obj[:place_published])
          meta_obj[:date].each do |d|
            xml.date_(d[:value], :type => d[:type])
          end if meta_obj.has_key?(:date)
          xml.url_(meta_obj[:url])
          xml.context_(meta_obj[:context])
        end
      end
    end

    def collection_key
      raise "Supply a collection_key attribute or implement a method"
    end


    def collection_originating_source
      raise "Supply a collection_originating_source attribute or implement a method"
    end
  end
end
