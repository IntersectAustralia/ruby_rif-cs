class PartyExample
  require 'date'
  include RIFCS::Party

  attr_reader :party_key

  def initialize(key='a key')
    @party_key = key
  end

  def party_group
    'test group'
  end

  def party_originating_source
    'tomato'
  end

  def party_type
    'person'
  end

  def party_date_modified
    Time.new(2012, 6, 14).utc
  end

  def party_identifiers
    [
      { value: 'http://example.com', type: 'uri' },
      { value: '123', type: 'local' }
    ]
  end
  
  def party_names
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

  def party_related_info
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

  def party_related_objects
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

  def party_locations
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
                value: "http://example.com/people/#{@party_key}",
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

  def party_coverage
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

  def party_descriptions
    [
      {
        value: 'A researcher',
        type: 'brief',
        'xml:lang' => 'en'
      },
      {
        value: 'Not just any researcher',
        type: 'full'
      }
    ]
  end

  def party_existence_dates
    [
      {
        start_date: {
          value: Time.new(2012, 6, 14).utc,
          date_format: 'UTC'
        },
        end_date: {
          value: Time.new(2013, 6, 14).utc,
          date_format: 'UTC'
        }
      }
    ]
  end

  def party_rights
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

  def party_subjects
    [
      {
        value: '123456',
        type: 'anzsrc-for'
      }
    ]
  end

end

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
        'xml:lang' => 'en'
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
          value: Time.new(2013, 6, 14).utc,
          date_format: 'UTC'
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
    'dataset'
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
        'xml:lang' => 'en'
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
          value: Time.new(2013, 6, 14).utc,
          date_format: 'UTC'
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

class ServiceExample
  include RIFCS::Service

  attr_reader :service_key, :service_group

  def initialize(key='service key')
    @service_key = key
    @service_group = 'Intersect Australia'
  end

  def service_originating_source
    'http://www.intersect.org.au'
  end

  def service_date_modified
    Time.new(2012, 6, 14).utc
  end

  def service_type
    'create'
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
          value: Time.new(2013, 6, 14).utc,
          date_format: 'UTC'
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
