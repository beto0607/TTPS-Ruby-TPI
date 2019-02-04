require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "Create user" do
    u = User.create(
      username: "test", 
      email: "test@tets.com",
      password: "test", 
      password_confirmation: "test",
      screen_name: "screen_name")
    assert u.persisted?
  end

  test "Email malformed" do
    u = User.create(
      email: "e@", 
      password: "email_malformed", 
      password_confirmation: "email_malformed",
      username: "email_malformed", 
      screen_name: "email_malformed"
    )
    assert_equal "is invalid", u.errors.messages[:email][0]
  end

  test "Cannot create user without all parameters" do
    u = User.create(
      password: "no_email", 
      password_confirmation: "no_email",
      username: "no_email", 
      screen_name: "no_email"
    )
    assert_not u.persisted?
    u = User.create(
      password: "no_username", 
      password_confirmation: "no_username",
      email: "no_username@email.com", 
      screen_name: "no_username"
    )
    assert_not u.persisted?
    u = User.create(
      password: "no_screen_name", 
      password_confirmation: "no_screen_name",
      username: "no_screen_name", 
      email: "no_screen_name@email.com"
    )
    assert_not u.persisted?
    u = User.create(
      screen_name: "no_password",
      username: "no_password", 
      email: "no_password@email.com"
    )
    assert_not u.persisted?
  end

  test "Password & password_confirmation must match" do
    u = User.create(
      password: "1", 
      password_confirmation: "2",
      username: "pass_test", 
      email: "pass_test@passtest.com",
      screen_name: "pass_test"
      )
    assert_not u.persisted?
  end

  test "Cannot create duplicated" do
    u1 = User.create(
      username: "dup_test", 
      email: "dup_test@duptest.com",
      password: "1", 
      password_confirmation: "1",
      screen_name: "dup_test"
      )
    assert u1.persisted?
    u2 = User.create(
      username: "dup_test", 
      email: "dup_test@duptest.com",
      password: "1", 
      password_confirmation: "1",
      screen_name: "dup_test")
    assert_not u2.persisted?
  end
end
