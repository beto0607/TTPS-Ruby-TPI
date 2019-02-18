require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "Create user" do
    assert FactoryGirl.build(:user).valid?
  end

  test "Email malformed" do
    user = FactoryGirl.build(:user, email: "e@")
    assert_not user.valid?
  end

  test "Lack of params - Email" do
    user = FactoryGirl.build(:user, email: nil)
    assert_not user.valid?
  end

  test "Lack of params - username" do
    user = FactoryGirl.build(:user, username: nil)
    assert_not user.valid?
  end

  test "Lack of params - screen_name" do
    user = FactoryGirl.build(:user, screen_name: nil)
    assert_not user.valid?
  end

  test "Lack of params - password" do
    user = FactoryGirl.build(:user, password: nil, password_confirmation: nil)
    assert_not user.valid?
  end

  test "Password & password_confirmation must match" do
    user = FactoryGirl.build(:user, password: "one_password", password_confirmation: "other_password")
    assert_not user.valid?
  end

  test "Cannot create duplicated" do
    user = FactoryGirl.create(:user)
    assert_not FactoryGirl.build(:user, username: user.username).valid?   
  end
end
