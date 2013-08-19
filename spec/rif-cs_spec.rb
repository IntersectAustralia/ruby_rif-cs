require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "RIFCS" do

  let (:address) {
    {
      electronic: [
        {
          type: 'email',
          value: 'joe@example.com'
        }
      ],
      physical: [
        {
          type: 'postalAddress',
          address_parts: [ { type: 'country', value: 'Austrlia' } ]
        }
      ]
    }
  }

  let (:spatial) {
    {
      value: '<gmlPoint gmlid="p21" srsName="http://www.opengis.net/def/crs/EPSG/0/4326"><gmlcoordinates>45.67, 88.56</gmlcoordinates></gmlPoint>',
      type: 'gml'
    }
  }

  before :each do
    @xml = Nokogiri::XML::Builder.new
  end

  it "creates XML from a simple list" do
    test_things = [
      { :value => '1st', :attr => 'some attribute' },
      { :value => '2nd', :attr => 'some other attribute' }
    ]
    @xml.root do |xml|
      RIFCS::list_of(test_things, 'things', xml)
    end
    @xml.to_xml.should == <<EOX
<?xml version="1.0"?>
<root>
  <things attr="some attribute">1st</things>
  <things attr="some other attribute">2nd</things>
</root>
EOX
  end

  it "creates the names element" do
    names = [
      {
        type: 'primary',
        date_from: Time.new(2012, 1, 1).utc,
        date_to: Time.new(2012, 1, 1).utc,
        xmllang: 'optional',
        name_parts: [ { type: 'given', value: 'Test' } ]
      }
    ]
    @xml.root do |xml|
      RIFCS::names(names, xml)
    end
    @xml.to_xml.should == <<EOX
<?xml version="1.0"?>
<root>
  <name dateFrom="2011-12-31 13:00:00 UTC" dateTo="2011-12-31 13:00:00 UTC" type="primary" xml:lang="optional">
    <namePart type="given">Test</namePart>
  </name>
</root>
EOX
  end

  it "creates the locations element" do
    locations = [
      {
        date_from: Time.new(2012, 6, 14).utc,
        addresses: [ address ]
      }
    ]
    @xml.root do |xml|
      RIFCS::locations(locations, xml)
    end
    @xml.to_xml.should == <<EOX
<?xml version="1.0"?>
<root>
  <location dateFrom="2012-06-13 14:00:00 UTC">
    <address>
      <electronic type="email">
        <value>joe@example.com</value>
      </electronic>
      <physical type="postalAddress" xml:lang="en">
        <addressPart type="country">Austrlia</addressPart>
      </physical>
    </address>
  </location>
</root>
EOX
  end

  it "creates spatial elements" do
    @xml.root do |xml|
      RIFCS::spatials([ spatial ], xml)
    end
    @xml.to_xml.should == <<EOX
<?xml version="1.0"?>
<root>
  <spatial type="gml" xml:lang="en">&lt;gmlPoint gmlid="p21" srsName="http://www.opengis.net/def/crs/EPSG/0/4326"&gt;&lt;gmlcoordinates&gt;45.67, 88.56&lt;/gmlcoordinates&gt;&lt;/gmlPoint&gt;</spatial>
</root>
EOX
  end

  describe "creates address elements" do
    it "creates electronic address elements" do
      @xml.root do |xml|
        RIFCS::electronic_addresses(address[:electronic], xml)
      end
      @xml.to_xml.should == <<EOX
<?xml version="1.0"?>
<root>
  <electronic type="email">
    <value>joe@example.com</value>
  </electronic>
</root>
EOX
    end

    it "creates physical address elements" do
      @xml.root do |xml|
        RIFCS::physical_addresses(address[:physical], xml)
      end
      @xml.to_xml.should == <<EOX
<?xml version="1.0"?>
<root>
  <physical type="postalAddress" xml:lang="en">
    <addressPart type="country">Austrlia</addressPart>
  </physical>
</root>
EOX
    end

    it "creates address elements" do
      @xml.root do |xml|
        RIFCS::addresses([ address ], xml)
      end
      @xml.to_xml.should == <<EOX
<?xml version="1.0"?>
<root>
  <address>
    <electronic type="email">
      <value>joe@example.com</value>
    </electronic>
    <physical type="postalAddress" xml:lang="en">
      <addressPart type="country">Austrlia</addressPart>
    </physical>
  </address>
</root>
EOX
    end
  end

  it "creates temporal elements" do
  end

  describe "creates the coverage elements" do
    let (:coverage) {
      [
        {
          spatials: [ spatial ],
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
    }

    it "creates temporal elements" do
      temporals = [
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
      
      @xml.root do |xml|
        RIFCS::temporals(temporals, xml)
      end
      @xml.to_xml.should == <<EOX
<?xml version="1.0"?>
<root>
  <temporal>
    <date dateFormat="UTC" type="dateFrom">2012-06-13 14:00:00 UTC</date>
    <date dateFormat="UTC" type="dateTo">2013-06-13 14:00:00 UTC</date>
    <text>Self destructs in 1 year</text>
  </temporal>
</root>
EOX
    end

    it "creates coverage elements" do
      @xml.root do |xml|
        RIFCS::coverage(coverage, xml)
      end
      @xml.to_xml.should == <<EOX
<?xml version="1.0"?>
<root>
  <coverage>
    <spatial type="gml" xml:lang="en">&lt;gmlPoint gmlid="p21" srsName="http://www.opengis.net/def/crs/EPSG/0/4326"&gt;&lt;gmlcoordinates&gt;45.67, 88.56&lt;/gmlcoordinates&gt;&lt;/gmlPoint&gt;</spatial>
    <temporal>
      <date dateFormat="UTC" type="dateFrom">2012-06-13 14:00:00 UTC</date>
      <date dateFormat="UTC" type="dateTo">2013-06-13 14:00:00 UTC</date>
      <text>Self destructs in 1 year</text>
    </temporal>
  </coverage>
</root>
EOX
    end
  end

  it "creates related_object elements" do
    related_objects = {
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

    @xml.root do |xml|
      RIFCS::related_objects(related_objects, xml)
    end
    @xml.to_xml.should == <<EOX
<?xml version="1.0"?>
<root>
  <relatedObject>
    <key>b party</key>
    <relation type="hasAssociationWith">
      <description>Supervisor</description>
    </relation>
  </relatedObject>
  <relatedObject>
    <key>some group</key>
    <relation type="isMemberOf"/>
  </relatedObject>
</root>
EOX
  end

  it "creates related_info elements" do
    related_info = [
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
    @xml.root do |xml|
      RIFCS::related_info(related_info, xml)
    end
    @xml.to_xml.should == <<EOX
<?xml version="1.0"?>
<root>
  <relatedInfo type="publication">
    <identifier type="isbn">111</identifier>
    <title>The Ordering of Things</title>
    <notes>Not available</notes>
  </relatedInfo>
</root>
EOX
  end

  it "creates rights elements" do
    rights = [
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

    @xml.root do |xml|
      RIFCS::rights(rights, xml)
    end
    @xml.to_xml.should == <<EOX
<?xml version="1.0"?>
<root>
  <rights>
    <rightsStatement rightsUri="http://www.intersect.org.au/policies">Copyright 2012 Intersect Australia Ltd.</rightsStatement>
    <licence rightsUri="http://creativecommons.org/licenses/by/3.0">Attribution (CC BY)</licence>
    <accessRights rightsUri="">Available to all without restriction</accessRights>
  </rights>
</root>
EOX
  end

  it "creates subject elements" do
    subjects = [
      {
        value: '123456',
        type: 'anzsrc-for',
        term_identifier: 'http://www.abs.gov.au/Ausstats/abs@.nsf/Latestproducts/DE380FC648D83027CA257418000447D6?opendocument'
      }
    ]
    @xml.root do |xml|
      RIFCS::subjects(subjects, xml)
    end
    @xml.to_xml.should == <<EOX
<?xml version="1.0"?>
<root>
  <subject termIdentifier="http://www.abs.gov.au/Ausstats/abs@.nsf/Latestproducts/DE380FC648D83027CA257418000447D6?opendocument" type="anzsrc-for" xml:lang="en">123456</subject>
</root>
EOX
  end

  it "creates existence_date elements" do
    existence_dates = [
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

    @xml.root do |xml|
      RIFCS::existence_dates(existence_dates, xml)
    end
    @xml.to_xml.should == <<EOX
<?xml version="1.0"?>
<root>
  <existenceDates>
    <startDate dateFormat="UTC">2012-06-13 14:00:00 UTC</startDate>
    <endDate dateFormat="UTC">2013-06-13 14:00:00 UTC</endDate>
  </existenceDates>
</root>
EOX
  end

end
