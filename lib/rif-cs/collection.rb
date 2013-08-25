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

            if respond_to?(:collection_identifiers)
              RIFCS::list_of(collection_identifiers, :identifier, xml)
            else
              xml.identifier(collection_key, :type => 'uri')
            end

            RIFCS::names(collection_names, xml) if respond_to?(:collection_names)

            RIFCS::locations(collection_locations, xml) if respond_to?(:collection_locations)

            RIFCS::coverage(collection_coverage, xml) if respond_to?(:collection_coverage)

            RIFCS::related_objects(collection_related_objects, xml) if respond_to?(:collection_related_objects)

            RIFCS::subjects(collection_subjects, xml) if respond_to?(:collection_subjects)

            RIFCS::list_of(collection_descriptions, :description, xml) if respond_to?(:collection_descriptions)

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
        if citation.has_key?(:full_citation)
          attributes = {}
          if !citation[:full_citation][:style].nil? && !citation[:full_citation][:style].blank?
            attributes[:style] = citation[:full_citation][:style]
          end
          xml.fullCitation_(citation[:full_citation][:value], attributes)
        end
        xml.citationMetadata_ do
          meta_obj = citation[:citation_metadata]
          xml.identifier(meta_obj[:identifier][:value])
          meta_obj[:contributor].each do |name|
            contributor_attributes = {}
            if !name[:seq].nil? && !name[:seq].blank?
              contributor_attributes[:seq] = name[:seq]
            end
            xml.contributor_(contributor_attributes) do
              name[:name_parts].each do |part|
                namepart_attributes = {}
                if !part[:type].nil? && !part[:type].blank?
                  namepart_attributes[:type] = part[:type]
                end
                xml.namePart_(part[:value], namepart_attributes)
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
        end if citation.has_key?(:citation_metadata)
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
