require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
describe "RIFCS::Service" do

  class ServiceExample
    include RIFCS::Service

    attr_reader :service_key, :service_group

    def initialize(key, group='Intersect Australia')
      @service_key = key || 'service key'
      @service_group = group
    end

    def service_originating_source
      'http://www.intersect.org.au'
    end

    def service_root
      {
        date_modified: Time.new(2012, 6, 14).utc,
        type: 'create'
      }
    end

    def service_identifiers
      [
        {
          type: 'local',
          value: 'hdl:1959.4/004_311'
        }
      ]
    end

    def service_names
      [
        {
          :date_from => Time.new(2012, 6, 14),
          :date_to => Time.new(2013, 6, 14),
          :type => 'create',
          :name_parts => [
            {
              :type => nil,
              :value => 'Autolab PGSTAT 12 Potentiostat'
            }
          ]
        }
      ]
    end

    def service_locations
      [
        {
          addresses: [
            {   
              electronic: [
                {
                  type: 'email',
                  value: 'joe@example.com'
                }, 
              ],
              physical: [
                {
                  type: 'postalAddress',
                  address_parts: [
                    {
                      type: 'country',
                      value: 'Austrlia'
                    },
                  ]
                },
                {
                  address_parts: [
                    {
                      type: 'telephoneNumber',
                      value: '+61 2 9123 4567'
                    }
                  ]
                }
              ]
            }
          ],
          spatials: [
            {
              value: '<gmlPoint gmlid="p21" srsName="http://www.opengis.net/def/crs/EPSG/0/4326"><gmlcoordinates>45.67, 88.56</gmlcoordinates></gmlPoint>',
              type: 'gml'
            }
          ]
        }
      ]
    end

    def service_coverage
      [
        {
          spatials: [
            {
              value: '<gmlPoint gmlid="p21" srsName="http://www.opengis.net/def/crs/EPSG/0/4326"><gmlcoordinates>45.67, 88.56</gmlcoordinates></gmlPoint>',
              type: 'gml'
            }
          ],
          temporals: [
            {
              dates: [
                {
                  value: Time.new(2012,6,14).utc,
                  date_format: 'UTC',
                  type: 'dateFrom'
                },
                {
                  value: Time.new(2013,6,14).utc,
                  date_format: 'UTC',
                  type: 'dateTo'
                },
              ],
              text: ['Self destructs in 1 year']
            }
          ]
        }
      ]
    end

    def service_related_objects
      {
        has_association_with: [
          {
            key: 'http://nla.gov.au/nla.party-593921',
          }
        ],
        is_presented_by: [
          {
            key: 'some group'
          }
        ]
      }
    end

    def service_subjects
      [
      ]
    end

    def service_descriptions
      [
        {
          type: 'deliverymethod',
          value: 'offline'
        },
        {
          type: 'full',
          value: 'General-purpose potentiostat.'
        }
      ]
    end

    def service_access_policies
      [
        { value: 'http://example.com/policy' }
      ]
    end

    def service_rights
      [
        {
          rights_statement: {
            rights_uri: 'http://www.intersect.org.au/policies',
            value: 'Copyright 2012 Intersect Australia Ltd.'
          },
          licence: {
            value: 'Attribution (CC BY)',
            rights_uri: 'http://creativecommons.org/licenses/by/3.0',
            type: ''
          },
          access_rights: {
            value: 'Available to all without restriction'
          }
        }
      ]
    end

    def service_existence_dates
      [
        {
          start_date: {
            value: Time.new(2012, 6, 14).utc,
            date_format: 'UTC'
          },
          end_date: {
          }
        }
      ]
    end

    def service_related_info
      [
        {
          type: 'website',
          identifier: {
            value: 'http://example.com/personalsites/foo',
            type: 'uri'
          },
          title: 'This person\'s blog',
          notes: 'Another blog'
        },
        {
          type: 'publication',
          identifier: {
            value: '111',
            type: 'isbn'
          },
          title: 'The Ordering of Things',
          notes: 'Not available'
        }
      ]
    end

  end

  it "should give a RIF-CS XML Service record for a model" do
    foo = ServiceExample.new(nil)
    puts foo.to_rifcs.to_xml
  end
end
