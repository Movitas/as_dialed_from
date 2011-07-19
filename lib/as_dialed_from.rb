$:.unshift(File.dirname(__FILE__)) unless
  $:.include?(File.dirname(__FILE__)) || $:.include?(File.expand_path(File.dirname(__FILE__)))

require 'as_dialed_from/metadata'
require 'as_dialed_from/number'

module AsDialedFrom
end
