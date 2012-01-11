# encoding: UTF-8

require 'test_helper'

class AsDialedFromTest < Test::Unit::TestCase

  should "prototype string with as_dialed_from method" do
    assert_equal "12155551212", "+12155551212".as_dialed_from("US")
  end

end
