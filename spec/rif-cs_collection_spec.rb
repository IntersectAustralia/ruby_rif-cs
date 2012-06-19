require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "RIFCS::Collection" do
  class CollectionExample
    require 'date'
    include RIFCS::Collection

    attr_reader :collection_key

    def initialize(key='a key')
      @collection_key = key
    end

    def collection_date_accessioned
      Time.new(2012, 6, 14).utc
    end

    def collection_group
      'test group'
    end

    def collection_originating_source
      'tomato'
    end

    def collection_type
      'person'
    end

    def collection_date_modified
      Time.new(2012, 6, 14).utc
    end

    def collection_identifiers
      [
        { value: 'http://example.com', type: 'uri' },
        { value: '123', type: 'local' }
      ]
    end
    
    def collection_names
      [
        {
          type: 'primary',
          name_parts: [
            { type: 'title', value: 'Dr' },
            { type: 'given', value: 'John' },
            { type: 'family', value: 'Doe' }
          ]
        },
      ]
    end

    def collection_related_info
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

    def collection_related_objects
      {
        has_association_with: [
          {
            key: 'b party',
            relation: {
              description: 'owner'
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

    def collection_locations
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
                  value: "http://example.com/people/#{@collection_key}",
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

    def collection_coverage
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

    def collection_descriptions
      [
        {
          value: 'A researcher',
          type: 'brief',
          'xmllang' => nil
        },
        {
          value: 'Not just any researcher',
          type: 'full'
        }
      ]
    end

    def collection_existence_dates
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

    def collection_rights
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

    def collection_subjects
      [
        {
          value: '123456',
          type: 'anzsrc-for'
        }
      ]
    end

    def collection_citation_info
      [
        {
          full_citation: {
            style: 'Harvard',
            value: 'Australian Bureau of Agricultural and Resource Economics 2001, Aquaculture development in Australia: a review of key economic issues, ABARE, Canberra.'
          },
          citation_metadata: {
            identifier: {
              type: 'isbn',
              value: '1234'
            },
            contributor: [
              {
                name_parts: [
                  { type: 'title', value: 'Dr' },
                  { type: 'given', value: 'Jane' },
                  { type: 'family', value: 'Doe' }
                ]
              }
            ],
            title: 'Aquaculture development in Australia: a review of key economic issues',
            edition: '1st',
            publisher: 'ABARE',
            place_published: 'Canberra',
            date: [
              {
                value: '2012-06-14',
                type: 'publicationDate'
              }
            ],
            url: 'http://example.com',
            context: 'local'
          }
        }
      ]
    end

  end

  it "should give a RIF-CS XML Collection record for a model" do
    foo = CollectionExample.new
    puts foo.to_rifcs.to_xml
  end

end
