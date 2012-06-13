require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "RIFCS:Party" do
  class PartyExample
    require 'date'
    include RIFCS:Party

    attr_reader party_key, party_group

    def initialize(key='a key')
      @party_key = key
    end

    def party_group
      'test group'
    end

    #def party_key
      #@key
    #end

    def party_originating_source
      'tomato'
    end

    def party_type
      'person'
    end

    def party_date_modified
      Time.now.to_s
    end

    def party_identifier
      [
        { value : 'http://example.com', type : 'uri' },
        { value : '123', type : 'local' }
      ]
    end
    
    def party_names
      [
        {
          type : 'primary',
          nameparts : {
            title : 'Dr',
            given : 'John',
            family : 'Doe'
          }
        },
      ]
    end

    def party_related_infos
      [
        {
          type : 'website',
          identifier : {
            value : 'http://example.com/personalsites/foo',
            type : 'uri'
          },
          title : 'This person\'s blog',
          notes : 'Another blog'
        },
        {
          type : 'publication',
          identifier : {
            value : '111',
            type : 'isbn'
          },
          title : 'The Ordering of Things',
          notes : 'Not available'
        }
      ]
    end

    def party_related_objects
      {
        hasAssociationWith : [
          {
            key : 'b party',
            relation : {
              description : 'Supervisor'
            }
          }
        ],
        isMemberOf : [
          {
            key : 'some group'
          }
        ]
      }
    end

    def party_locations
      [
        {
          datefrom : Time.now,
          addresses : [
            {
              electronic : [
                {
                  type : 'email',
                  value : 'joe@example.com'
                },
                {
                  type : 'uri',
                  value : "http://example.com/people/#{@party_key}",
                  args : [
                    { value : 'placeholder', required : 'false' }
                  ]
                }
              ],
              physical : [
                {
                  type : 'postalAddress',
                  addressparts : [
                    {
                      type : 'country',
                      value : 'Austrlia'
                    },
                  ]
                },
                {
                  addressparts : [
                    {
                      type : 'telephoneNumber',
                      value : '+61 2 9123 4567'
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
          spatials : [
            {
              value : '<gmlPoint gmlid="p21" srsName="http://www.opengis.net/def/crs/EPSG/0/4326"><gmlcoordinates>45.67, 88.56</gmlcoordinates></gmlPoint>',
              type : 'gml'
            }
          ],
          temporals : [
            {
              dates : [
                {
                  value : Time.now.utc,
                  dateformat : 'UTC',
                  type : 'dateFrom'
                },
                {
                  value : (DateTime.now >> 12).to_time.utc,
                  dateformat : 'UTC',
                  type : 'dateTo'
                },
              ],
              text : ['Self destructs in 1 year']
            }
          ]
        }
      ]
    end

    def party_description
      [
        {
          value : 'A researcher',
          type : 'brief',
          'xmllang' : nil
        },
        {
          value : 'Not just any researcher',
          type : 'full'
        }
      ]
    end

    def party_existence_dates
      [
        {
          startdate : {
            value : Time.now.utc,
            dateformat : 'UTC'
          },
          enddate : {
          }
        }
      ]
    end

    def party_rights
      [
        {
          rightsstatement : {
            rightsuri : 'http://www.intersect.org.au/policies',
            value : 'Copyright 2012 Intersect Australia Ltd.'
          },
          licence : {
            value : 'Attribution (CC BY)',
            rightsuri : 'http://creativecommons.org/licenses/by/3.0',
            type : ''
          },
          accessrights : {
            value : 'Available to all without restriction'
          }
        }
      ]
    end

    def party_subjects
      [
        {
          value : '123456',
          type : 'anzsrc-for'
        }
      ]
    end

  end

  it "should give RIF-CS XML for a model" do
    foo = PartyExample.new
    puts foo.to_rifcs.to_xml
  end

  describe "should not display missing optional components" do
    it "should not show originating source" do
      class PartyExampleSub < PartyExample
        include RIFCS:Party
        undef_method party_originating_source
      end
      foo = PartyExampleSub.new
      puts foo.to_rifcs.to_xml
    end
  end

end
