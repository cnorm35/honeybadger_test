require "test_helper"

module Api
  module V1
    class NotificationsControllerTest < ActionDispatch::IntegrationTest
      setup do
      end

      test "new_returns_200" do
        post api_v1_notifications_path, params: {}, as: :json
      end
    end
  end
end

