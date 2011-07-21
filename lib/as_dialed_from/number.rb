# encoding: UTF-8

module AsDialedFrom
  
  class Number
    
    attr_reader :number
    
    def initialize(number)
      @number = number
      
      # Pre-compute stuff
      country_code
      metadata
      
      @number
    end
    
    def as_dialed_from(from_country)
      # Convert numeric country code to region id
      from_country = Metadata.country_code_to_region[from_country][0] if from_country.is_a? Integer or from_country.to_i.nonzero?
      
      from_metadata = Metadata.for_region(from_country)
      raise "Could not find valid metadata for from_country" unless from_metadata
      
      if from_country == Metadata.country_code_to_region[country_code][0]
        # If we're calling within the same country, just prepend the national number with the national prefix
        "#{leading_zero}#{metadata[:national_prefix]}#{national_number}"
      else
        # If we're calling out of country, we need to dial the exit code and the destination country code before the number
        "#{exit_code(from_metadata[:international_prefix])}#{country_code}#{leading_zero}#{national_number}"
      end
    end
    
    def country_code
      @country_code ||= determine_country_code
    end
    
    def determine_country_code
      raise "+<country_code> is required at the beginning of the number" unless @number[0,1] == "+"
      
      # Test the leading digits to find a valid country_code
      # Country codes are not ambiguous (ex. 1 is valid, and there is no 1X or 1XX)
      (1..3).each do |length|
        possible_country_code = @number[1,length]
        
        return possible_country_code if Metadata.country_code_to_region[possible_country_code]
      end
      
      raise "No valid country code was present"
    end
    
    def exit_code(international_prefix)
      international_prefix.delete("[]").match international_prefix
    end
    
    def metadata
      @metadata ||= Metadata.for_region(Metadata.country_code_to_region[country_code][0])
      raise "Could not find valid metadata for number" unless @metadata
      @metadata
    end
    
    def national_number
      @national_number ||= determine_national_number
    end
    
    def determine_national_number
      n = @number.gsub "+#{country_code}", ""
      n.match metadata[:national_number_format] if metadata[:national_number_format]
      n
    end
    
    def leading_zero
      "0" if metadata[:leading_zero_possible]
    end
    
  end
  
end