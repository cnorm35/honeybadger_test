require "test_helper"

module Api
  module V1
    class NotificationsControllerTest < ActionDispatch::IntegrationTest
      setup do
      end

      test "new_returns_200" do
        post api_v1_notifications_path, params: {}, as: :json
        assert_response :success
      end

      test "new_returns_the_correct_response" do
        post api_v1_notifications_path, params: {}, as: :json
        json_response = JSON.parse(response.body)
        assert_equal Hash.new, json_response
      end
    end
  end
end

