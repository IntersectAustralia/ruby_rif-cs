module RIFCS
  module Party
    include RIFCS
    require 'nokogiri'

    def to_rifcs(encoding='UTF-8')
      Nokogiri::XML::Builder.new(:encoding => encoding) do |xml|
        xml.registryObject_(:group => party_group) do

          xml.key_ party_key
          xml.originatingSource_ party_originating_source if respond_to?(:party_originating_source)

          xml.party_(:dateModified => party_date_modified, :type => party_type) do
            RIFCS::list_of(party_identifiers, :identifiers, xml) if respond_to?(:party_identifiers)

            RIFCS::names(party_names, xml) if respond_to?(:party_names)

            RIFCS::locations(party_locations, xml) if respond_to?(:party_locations)

            RIFCS::coverage(party_coverage, xml) if respond_to?(:party_coverage)

            RIFCS::list_of(party_descriptions, :descriptions, xml) if respond_to?(:party_descriptions)

            RIFCS::existence_dates(party_existence_dates, xml) if respond_to?(:party_existence_dates)

            RIFCS::related_info(party_related_info, xml) if respond_to?(:party_related_infos)

            RIFCS::related_objects(party_related_objects, xml) if respond_to?(:party_related_objects)

            RIFCS::rights(party_rights, xml) if respond_to?(:party_rights)

            RIFCS::subjects(party_subjects, xml) if respond_to?(:party_subjects)

          end # party
        end
      end
    end

    def party_key
      raise "Supply a party_key attribute or implement a method"
    end


  end
end
