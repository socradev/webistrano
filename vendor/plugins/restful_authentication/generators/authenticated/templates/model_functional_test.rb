require File.dirname(__FILE__) + '/../test_helper'
require '<%= model_controller_file_name %>_controller'

# Re-raise errors caught by the controller.
class <%= model_controller_class_name %>Controller; def rescue_action(e) raise e end; end

class <%= model_controller_class_name %>ControllerTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  # Then, you can remove it from this and the units test.
  include AuthenticatedTestHelper

  fixtures :<%= table_name %>

  def setup
    @controller = <%= model_controller_class_name %>Controller.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  test "should_allow_signup" do
    assert_difference '<%= class_name %>.count' do
      create_<%= file_name %>
      assert_response :redirect
    end
  end

  test "should_require_login_on_signup" do
    assert_no_difference '<%= class_name %>.count' do
      create_<%= file_name %>(:login => nil)
      assert assigns(:<%= file_name %>).errors[:login]
      assert_response :success
    end
  end

  test "should_require_password_on_signup" do
    assert_no_difference '<%= class_name %>.count' do
      create_<%= file_name %>(:password => nil)
      assert assigns(:<%= file_name %>).errors[:password]
      assert_response :success
    end
  end

  test "should_require_password_confirmation_on_signup" do
    assert_no_difference '<%= class_name %>.count' do
      create_<%= file_name %>(:password_confirmation => nil)
      assert assigns(:<%= file_name %>).errors[:password_confirmation]
      assert_response :success
    end
  end

  test "should_require_email_on_signup" do
    assert_no_difference '<%= class_name %>.count' do
      create_<%= file_name %>(:email => nil)
      assert assigns(:<%= file_name %>).errors[:email]
      assert_response :success
    end
  end
  <% if options[:include_activation] %>
  test "should_activate_user" do
    assert_nil <%= class_name %>.authenticate('aaron', 'test')
    get :activate, :activation_code => <%= table_name %>(:aaron).activation_code
    assert_redirected_to '/'
    assert_not_nil flash[:notice]
    assert_equal <%= table_name %>(:aaron), <%= class_name %>.authenticate('aaron', 'test')
  end
  
  test "should_not_activate_user_without_key" do
    get :activate
    assert_nil flash[:notice]
  rescue ActionController::RoutingError
    # in the event your routes deny this, we'll just bow out gracefully.
  end

  test "should_not_activate_user_with_blank_key" do
    get :activate, :activation_code => ''
    assert_nil flash[:notice]
  rescue ActionController::RoutingError
    # well played, sir
  end<% end %>

  protected
    def create_<%= file_name %>(options = {})
      post :create, :<%= file_name %> => { :login => 'quire', :email => 'quire@example.com',
        :password => 'quire', :password_confirmation => 'quire' }.merge(options)
    end
end
