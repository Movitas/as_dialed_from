# encoding: UTF-8

require File.expand_path(File.dirname(__FILE__) + "/../test_helper")

class Number < Test::Unit::TestCase
  
  ALPHA_NUMERIC_NUMBER = "+180074935247"
  AR_MOBILE = "+5491187654321"
  AR_NUMBER = "+541187654321"
  AU_NUMBER = "+61236618300"
  BS_MOBILE = "+12423570000"
  BS_NUMBER = "+12423651234"
  DE_NUMBER = "+4930123456"
  DE_SHORT_NUMBER = "+491234"
  GB_MOBILE = "+447912345678"
  GB_NUMBER = "+442070313000"
  IT_MOBILE = "+39345678901"
  IT_NUMBER = "+39236618300"
  MX_MOBILE1 = "+5212345678900"
  MX_MOBILE2 = "+5215512345678"
  MX_NUMBER1 = "+523312345678"
  MX_NUMBER2 = "+528211234567"
  NZ_NUMBER = "+6433316005"
  SG_NUMBER = "+6565218000"
  US_LONG_NUMBER = "+165025300001"
  US_NUMBER = "+16502530000"
  US_PREMIUM = "+19002530000"
  US_LOCAL_NUMBER = "+12530000"
  US_SHORT_BY_ONE_NUMBER = "+1650253000"
  US_TOLLFREE = "+18002530000"
  
  test "should require an argument" do
    assert_raise(ArgumentError) { AsDialedFrom::Number.new }
  end
  
  test "should instantiate with a valid phone number" do
    assert AsDialedFrom::Number.new US_NUMBER
  end
  
  test "should determine country code from string" do
    assert_equal "1",  AsDialedFrom::Number.new(US_NUMBER ).country_code
    assert_equal "52", AsDialedFrom::Number.new(MX_NUMBER1).country_code
    assert_equal "39", AsDialedFrom::Number.new(IT_NUMBER ).country_code
  end
  
  test "should raise an error if no valid country code was found" do
    assert_raise(RuntimeError) { AsDialedFrom::Number.new "+9991234567890" }    
  end
  
  test "should return national number" do
    assert_equal "6502530000", AsDialedFrom::Number.new(US_NUMBER).national_number
  end
  
  test "should return a number to dial using as_dialed_from" do
    # Intra-country calls
    assert_equal "16502530000", AsDialedFrom::Number.new(US_NUMBER).as_dialed_from("US")
    assert_equal "013312345678", AsDialedFrom::Number.new(MX_NUMBER1).as_dialed_from("MX")
    
    # MX cell numbers
    assert_equal "0112345678900", AsDialedFrom::Number.new(MX_MOBILE1).as_dialed_from("MX")
    assert_equal "0115212345678900", AsDialedFrom::Number.new(MX_MOBILE1).as_dialed_from("US")
    
    # US <-> MX
    assert_equal "0016502530000", AsDialedFrom::Number.new(US_NUMBER).as_dialed_from("MX")
    assert_equal "011523312345678", AsDialedFrom::Number.new(MX_NUMBER1).as_dialed_from("US")
    
    assert_equal "0019002530000", AsDialedFrom::Number.new(US_PREMIUM).as_dialed_from("DE")
    # assert_equal "16502530000", AsDialedFrom::Number.new(US_NUMBER).as_dialed_from("BS")
    # assert_equal "0~016502530000", AsDialedFrom::Number.new(US_NUMBER).as_dialed_from("PL")
    assert_equal "011447912345678", AsDialedFrom::Number.new(GB_MOBILE).as_dialed_from("US")
    assert_equal "00491234", AsDialedFrom::Number.new(DE_SHORT_NUMBER).as_dialed_from("GB")
    
    # assert_equal "1234", AsDialedFrom::Number.new(DE_SHORT_NUMBER).as_dialed_from("DE")
    assert_equal "011390236618300", AsDialedFrom::Number.new(IT_NUMBER).as_dialed_from("US")
    assert_equal "0236618300", AsDialedFrom::Number.new(IT_NUMBER).as_dialed_from("IT")
    assert_equal "390236618300", AsDialedFrom::Number.new(IT_NUMBER).as_dialed_from("SG")
    assert_equal "65218000", AsDialedFrom::Number.new(SG_NUMBER).as_dialed_from("SG")
    assert_equal "0115491187654321", AsDialedFrom::Number.new(AR_MOBILE).as_dialed_from("US")
  end
  
  test "as_dialed_from should accept a country code string as input" do
    assert_equal "16502530000", AsDialedFrom::Number.new(US_NUMBER).as_dialed_from("1")
  end
  
  test "as_dialed_from should accept a country code integer as input" do
    assert_equal "16502530000", AsDialedFrom::Number.new(US_NUMBER).as_dialed_from(1)
  end
  
  test "as_dialed_from should accept a caller id number as input" do
    assert_equal "16502530000", AsDialedFrom::Number.new(US_NUMBER).as_dialed_from(US_NUMBER)
    assert_equal "0016502530000", AsDialedFrom::Number.new(US_NUMBER).as_dialed_from(MX_NUMBER1)
  end

end
