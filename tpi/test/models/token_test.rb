require 'test_helper'

class TokensTest < ActiveSupport::TestCase
  test "Cannot be created without a date or token" do
    assert_not Token.new.valid?
  end
end
