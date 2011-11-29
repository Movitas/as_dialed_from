require 'net/http'
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
      require 'xmlsimple'

      puts "Parsing XML file"

      xml = File.read LOCAL_XML_FILE
      phone_number_meta_data = XmlSimple.xml_in xml, { 'KeyAttr' => 'id', 'ForceArray' => false }
      territories = phone_number_meta_data['territories']['territory']

      country_code_to_region_code_map = {}

      print "Writing territories "

      territories.each do |territory, data|
        print "#{territory} "

        hash ||= {}

        %w[
          countryCode
          internationalPrefix
          leadingZeroPossible
          nationalPrefix
        ].each do |xml_attribute|
          hash[underscore(xml_attribute).to_sym] = data[xml_attribute] if data[xml_attribute]
        end

        hash[:national_number_pattern] = data['generalDesc']['nationalNumberPattern'] if data['generalDesc'] and data['generalDesc']['nationalNumberPattern']

        file = File.new "#{TERRITORIES_DIRECTORY}/#{territory}.yml", "w"
        file.write hash.to_yaml
        file.close

        country_code_to_region_code_map[data['countryCode']] ||= []

        if data['mainCountryForCode']
          country_code_to_region_code_map[data['countryCode']].insert 0, territory
        else
          country_code_to_region_code_map[data['countryCode']].push territory
        end
      end

      puts "\nWriting country code map"

      file = File.new COUNTRY_CODES_FILE, "w"
      file.write country_code_to_region_code_map.to_yaml
      file.close

      puts "Done!"
    end

    def self.underscore(camel_cased_word)
      word = camel_cased_word.to_s.dup
      word.gsub!(/::/, '/')
      word.gsub!(/([A-Z\d]+)([A-Z][a-z])/,'\1_\2')
      word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
      word.tr!("-", "_")
      word.downcase!
      word
    end

  end

end
