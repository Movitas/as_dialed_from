# encoding: UTF-8

require File.expand_path(File.dirname(__FILE__) + "/test_helper")

class AsDialedFromTest < Test::Unit::TestCase
  
  test "prototype string with as_dialed_from method" do
    assert_equal "12155551212", "+12155551212".as_dialed_from("US")
  end
  
end
