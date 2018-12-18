require 'test_helper'


class UsersTest < ActiveSupport::TestCase
  test "user cannot be created without username, email, password or screen_name" do
    u = User.new
    assert_not u.save
  end
  test "user can be created with username, email, password or screen_name" do
    u = User.new
    u.username = "user_test1"
    u.password = "user_test1"
    u.email = "user_test1@email.com"
    u.screen_name = "user_test1"
    assert u.save
    u.destroy
  end
  test "user cannot be duplicated" do
    u = User.create(username:"user_test1",password:"user_test1",screen_name:"user_test1",email:"user_test1@email.com")
    assert u.valid?
    assert_not User.create(username:"user_test1",password:"user_test1",screen_name:"user_test1",email:"user_test1@email.com").valid?
    u.destroy
  end
end
