require File.dirname(__FILE__) + '/../test_helper'

class <%= class_name %>Test < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper
  fixtures :<%= table_name %>

  test "should_create_<%= file_name %>" do
    assert_difference '<%= class_name %>.count' do
      <%= file_name %> = create_<%= file_name %>
      assert !<%= file_name %>.new_record?, "#{<%= file_name %>.errors.full_messages.to_sentence}"
    end
  end

  test "should_require_login" do
    assert_no_difference '<%= class_name %>.count' do
      u = create_<%= file_name %>(:login => nil)
      assert u.errors[:login]
    end
  end

  test "should_require_password" do
    assert_no_difference '<%= class_name %>.count' do
      u = create_<%= file_name %>(:password => nil)
      assert u.errors[:password]
    end
  end

  test "should_require_password_confirmation" do
    assert_no_difference '<%= class_name %>.count' do
      u = create_<%= file_name %>(:password_confirmation => nil)
      assert u.errors[:password_confirmation]
    end
  end

  test "should_require_email" do
    assert_no_difference '<%= class_name %>.count' do
      u = create_<%= file_name %>(:email => nil)
      assert u.errors[:email]
    end
  end

  test "should_reset_password" do
    <%= table_name %>(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal <%= table_name %>(:quentin), <%= class_name %>.authenticate('quentin', 'new password')
  end

  test "should_not_rehash_password" do
    <%= table_name %>(:quentin).update_attributes(:login => 'quentin2')
    assert_equal <%= table_name %>(:quentin), <%= class_name %>.authenticate('quentin2', 'test')
  end

  test "should_authenticate_<%= file_name %>" do
    assert_equal <%= table_name %>(:quentin), <%= class_name %>.authenticate('quentin', 'test')
  end

  test "should_set_remember_token" do
    <%= table_name %>(:quentin).remember_me
    assert_not_nil <%= table_name %>(:quentin).remember_token
    assert_not_nil <%= table_name %>(:quentin).remember_token_expires_at
  end

  test "should_unset_remember_token" do
    <%= table_name %>(:quentin).remember_me
    assert_not_nil <%= table_name %>(:quentin).remember_token
    <%= table_name %>(:quentin).forget_me
    assert_nil <%= table_name %>(:quentin).remember_token
  end

  test "should_remember_me_for_one_week" do
    before = 1.week.from_now.utc
    <%= table_name %>(:quentin).remember_me_for 1.week
    after = 1.week.from_now.utc
    assert_not_nil <%= table_name %>(:quentin).remember_token
    assert_not_nil <%= table_name %>(:quentin).remember_token_expires_at
    assert <%= table_name %>(:quentin).remember_token_expires_at.between?(before, after)
  end

  test "should_remember_me_until_one_week" do
    time = 1.week.from_now.utc
    <%= table_name %>(:quentin).remember_me_until time
    assert_not_nil <%= table_name %>(:quentin).remember_token
    assert_not_nil <%= table_name %>(:quentin).remember_token_expires_at
    assert_equal <%= table_name %>(:quentin).remember_token_expires_at, time
  end

  test "should_remember_me_default_two_weeks" do
    before = 2.weeks.from_now.utc
    <%= table_name %>(:quentin).remember_me
    after = 2.weeks.from_now.utc
    assert_not_nil <%= table_name %>(:quentin).remember_token
    assert_not_nil <%= table_name %>(:quentin).remember_token_expires_at
    assert <%= table_name %>(:quentin).remember_token_expires_at.between?(before, after)
  end

  protected
    def create_<%= file_name %>(options = {})
      <%= class_name %>.create({ :login => 'quire', :email => 'quire@example.com', :password => 'quire', :password_confirmation => 'quire' }.merge(options))
    end
end
