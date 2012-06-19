require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "RIFCS::Activity" do
  class ActivityExample
    require 'date'
    include RIFCS::Activity

    attr_reader :activity_key

    def initialize(key='a key')
      @activity_key = key
    end

    def activity_group
      'test group'
    end

    def activity_originating_source
      'tomato'
    end

    def activity_type
      'program'
    end

    def activity_date_modified
      Time.new(2012, 6, 14).utc
    end

    def activity_identifiers
      [
        { value: 'http://example.com', type: 'uri' },
        { value: '123', type: 'local' }
      ]
    end
    
    def activity_names
      [
        {
          type: 'primary',
          name_parts: [
            { value: 'Testing of software' },
          ]
        },
      ]
    end

    def activity_related_info
      [
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

    def activity_related_objects
      {
        has_association_with: [
          {
            key: 'b party',
            relation: {
              description: 'Supervisor'
            }
          }
        ],
        is_member_of: [
          {
            key: 'some group'
          }
        ]
      }
    end

    def activity_locations
      [
        {
          date_from: Time.new(2012, 6, 14).utc,
          addresses: [
            {
              electronic: [
                {
                  type: 'email',
                  value: 'joe@example.com'
                },
                {
                  type: 'uri',
                  value: "http://example.com/people/#{@activity_key}",
                  args: [
                    { value: 'placeholder', required: 'false' }
                  ]
                }
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
          ]
        }
      ]
    end

    def activity_coverage
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
                  value: Time.new(2012, 6, 14).utc,
                  date_format: 'UTC',
                  type: 'dateFrom'
                },
                {
                  value: Time.new(2013, 6, 14).utc,
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

    def activity_descriptions
      [
        {
          value: 'An activity',
          type: 'brief',
          'xmllang' => nil
        },
        {
          value: 'Not just any activity',
          type: 'full'
        }
      ]
    end

    def activity_existence_dates
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

    def activity_rights
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

    def activity_subjects
      [
        {
          value: '123456',
          type: 'anzsrc-for'
        }
      ]
    end

  end

  it "should give a RIF-CS XML Activity record for a model" do
    expected = IO.read(File.join(File.dirname(__FILE__), 'files', 'activity.xml'))
    activity = ActivityExample.new
    activity.to_rifcs.to_xml.should eq(expected)
  end

end
