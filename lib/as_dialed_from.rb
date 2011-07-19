$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'as_dialed_from/metadata'
require 'as_dialed_from/number'

class String
  def as_dialed_from(from_country)
    AsDialedFrom::Number.new(self).as_dialed_from(from_country)
  end
end
