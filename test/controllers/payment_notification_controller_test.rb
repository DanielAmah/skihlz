require 'test_helper'

class PaymentNotificationControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get payment_notification_create_url
    assert_response :success
  end

end
