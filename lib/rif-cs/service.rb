module RIFCS
  module Service
    include RIFCS
    require 'nokogiri'

    def to_registry_node(encoding='UTF-8')
      Nokogiri::XML::Builder.new(:encoding => encoding) do |xml|
        xml.registryObject_(:group => service_group) do
          xml.key_ service_key
          xml.originatingSource_ service_originating_source if respond_to?(:service_originating_source)

          xml.service_(:dateModified => service_date_modified, :type => service_type) do
            RIFCS::list_of(service_identifiers, :identifiers, xml) if respond_to?(:service_identifiers)

            RIFCS::names(service_names, xml) if respond_to?(:service_names)

            RIFCS::locations(service_locations, xml) if respond_to?(:service_locations)

            RIFCS::coverage(service_coverage, xml) if respond_to?(:service_coverage)

            RIFCS::related_objects(service_related_objects, xml) if respond_to?(:service_related_objects)

            RIFCS::subjects(service_subjects, xml) if respond_to?(:service_subjects)

            RIFCS::list_of(service_descriptions, :descriptions, xml) if respond_to?(:service_descriptions)

            RIFCS::list_of(service_access_policies, :access_policies, xml) if respond_to?(:service_access_policies)

            RIFCS::rights(service_rights, xml) if respond_to?(:service_rights)

            RIFCS::existence_dates(service_existence_dates, xml) if respond_to?(:service_existence_dates)

            RIFCS::related_info(service_related_info, xml) if respond_to?(:service_related_info)
          end # service
        end
      end
    end

  end
end
