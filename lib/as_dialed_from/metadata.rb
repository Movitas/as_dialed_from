require 'net/http'
require 'xmlsimple'
require 'yaml'

module AsDialedFrom
  
  class Metadata
    RESOURCES_DIRECTORY   = File.dirname(__FILE__) + "/../../resources/"
    TERRITORIES_DIRECTORY = RESOURCES_DIRECTORY + "/territories"
    LOCAL_XML_FILE        = RESOURCES_DIRECTORY + "/PhoneNumberMetaData.xml"
    COUNTRY_CODES_FILE    = "#{RESOURCES_DIRECTORY}/country_codes.yml"
    
    UPSTREAM_URL = "http://libphonenumber.googlecode.com/svn/trunk/resources/PhoneNumberMetaData.xml"
    
    attr_accessor :data
    
    def initialize; end
    
    def self.for_region(region_code)
      YAML::load_file "#{TERRITORIES_DIRECTORY}/#{region_code}.yml"
    end
    
    def self.country_code_to_region
      YAML::load_file COUNTRY_CODES_FILE
    end
    
    def self.download
      file = File.new LOCAL_XML_FILE, "w"
      file.write Net::HTTP.get(URI.parse(UPSTREAM_URL))
      file.close
    end
    
    def self.parse
      xml = File.read LOCAL_XML_FILE
      phone_number_meta_data = XmlSimple.xml_in xml, { 'KeyAttr' => 'id', 'ForceArray' => false }
      territories = phone_number_meta_data['territories']['territory']
      
      country_code_to_region_code_map = {}
      
      territories.each do |territory, data|
        file = File.new "#{TERRITORIES_DIRECTORY}/#{territory}.yml", "w"
        file.write data.to_yaml
        file.close
        
        country_code_to_region_code_map[data['countryCode']] ||= []
        
        if data['mainCountryForCode']
          country_code_to_region_code_map[data['countryCode']].insert 0, territory
        else
          country_code_to_region_code_map[data['countryCode']].push territory
        end
      end
      
      file = File.new COUNTRY_CODES_FILE, "w"
      file.write country_code_to_region_code_map.to_yaml
      file.close
    end
    
  end
  
end
