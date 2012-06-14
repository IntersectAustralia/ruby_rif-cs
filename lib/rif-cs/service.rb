module RIFCS
  module Service
    require 'nokogiri'

    def to_rifcs(encoding='UTF-8')
      Nokogiri::XML::Builder.new(:encoding => encoding) do |xml|
        xml.registryObject_(:group => service_group) do
          xml.key_ service_key
          xml.originatingSource_ service_originating_source if respond_to?(:service_originating_source)

          xml.service_(:dateModified => service_root[:date_modified], :type => service_root[:type]) do
          end
        end
      end
    end

  end
end
