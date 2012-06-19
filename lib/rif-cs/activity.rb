module RIFCS
  module Activity
    include RIFCS
    require 'nokogiri'

    def to_rifcs(encoding='UTF-8')
      Nokogiri::XML::Builder.new(:encoding => encoding) do |xml|
        xml.registryObject_(:group => activity_group) do

          xml.key_ activity_key
          xml.originatingSource_ activity_originating_source if respond_to?(:activity_originating_source)

          xml.activity_(:dateModified => activity_date_modified, :type => activity_type) do
            RIFCS::list_of('activity', :identifiers, xml)

            RIFCS::names(activity_names, xml) if respond_to?(:activity_names)

            RIFCS::locations(activity_locations, xml) if respond_to?(:activity_locations)

            RIFCS::coverage(activity_coverage, xml) if respond_to?(:activity_coverage)

            RIFCS::list_of('activity', :descriptions, xml)

            RIFCS::existence_dates(activity_existence_dates, xml) if respond_to?(:activity_existence_dates)

            RIFCS::related_info(activity_related_info, xml) if respond_to?(:activity_related_infos)

            RIFCS::related_objects(activity_related_objects, xml) if respond_to?(:activity_related_objects)

            RIFCS::rights(activity_rights, xml) if respond_to?(:activity_rights)

            RIFCS::subjects(activity_subjects, xml) if respond_to?(:activity_subjects)

          end # activity
        end
      end
    end

    def activity_key
      raise "Supply a activity_key attribute or implement a method"
    end


  end
end
