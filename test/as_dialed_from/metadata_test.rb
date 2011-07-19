# encoding: UTF-8

require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class MetadataTest < Test::Unit::TestCase
  
  test "load US metadata" do
    metadata = AsDialedFrom::Metadata.for_region "US"
    assert_equal "1",   metadata['countryCode']
    assert_equal "011", metadata['internationalPrefix']
    assert_equal "1",   metadata['nationalPrefix']
  end
  
  test "load MX metadata" do
    metadata = AsDialedFrom::Metadata.for_region "MX"
    assert_equal "52",    metadata['countryCode']
    assert_equal "0[09]", metadata['internationalPrefix']
    assert_equal "01",    metadata['nationalPrefix']
  end
  
end
