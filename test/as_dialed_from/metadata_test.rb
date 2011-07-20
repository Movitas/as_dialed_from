# encoding: UTF-8

require File.expand_path(File.dirname(__FILE__) + '/../test_helper')

class MetadataTest < Test::Unit::TestCase
  
  test "load US metadata" do
    metadata = AsDialedFrom::Metadata.for_region "US"
    assert_equal "1",   metadata[:country_code]
    assert_equal "011", metadata[:international_prefix]
    assert_equal "1",   metadata[:national_prefix]
  end
  
  test "load MX metadata" do
    metadata = AsDialedFrom::Metadata.for_region "MX"
    assert_equal "52",    metadata[:country_code]
    assert_equal "0[09]", metadata[:international_prefix]
    assert_equal "01",    metadata[:national_prefix]
  end
  
  test "under_score camelCased words" do
    assert_equal "one_two_three", AsDialedFrom::Metadata.underscore("oneTwoThree")
    assert_equal "one_two_three", AsDialedFrom::Metadata.underscore("OneTwoThree")
  end
  
end
