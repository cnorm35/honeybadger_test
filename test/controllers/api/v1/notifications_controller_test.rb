require "test_helper"

module Api
  module V1
    class NotificationsControllerTest < ActionDispatch::IntegrationTest
      setup do
        @alert_payload = {
          "RecordType": "Bounce",
          "Type": "SpamNotification",
          "TypeCode": 512,
          "Name": "Spam notification",
          "Tag": "",
          "MessageStream": "outbound",
          "Description": "The message was delivered, but was either blocked by the user, or classified as spam, bulk mail, or had rejected content.",
          "Email": "zaphod@example.com",
          "From": "notifications@honeybadger.io",
          "BouncedAt": "2023-02-27T21:41:30Z",
        }
        @alert_payload_slack_message = "SPAM EMAIL ---- #{@alert_payload[:Email]} - #{@alert_payload[:Description]}"

        @no_alert_payload = {
          "RecordType": "Bounce",
          "MessageStream": "outbound",
          "Type": "HardBounce",
          "TypeCode": 1,
          "Name": "Hard bounce",
          "Tag": "Test",
          "Description": "The server was unable to deliver your message (ex: unknown user, mailbox not found).",
          "Email": "arthur@example.com",
          "From": "notifications@honeybadger.io",
          "BouncedAt": "2019-11-05T16:33:54.9070259Z",
        }
        @active_api_key = api_keys(:active).value
        @inactive_api_key = api_keys(:inactive).value
        @valid_auth_headers = { "Authorization" => @active_api_key }
      end

      test "create_returns_200" do
        post api_v1_notifications_path, headers: @valid_auth_headers, params: {}, as: :json
        assert_response :success
      end

      test "create_notification_returns_json" do
        post api_v1_notifications_path, headers: @valid_auth_headers, params: {}, as: :json
        json_response = JSON.parse(response.body)
        assert_equal Hash.new, json_response
      end

      test "spam_report_sends_new_notification" do
        post api_v1_notifications_path, headers: @valid_auth_headers, params: @alert_payload, as: :json
        json_response = JSON.parse(response.body)
        assert_equal json_response, { slack_message: @alert_payload_slack_message }.as_json
      end

      test "bounce_does_not_send_notification" do
        post api_v1_notifications_path, headers: @valid_auth_headers, params: @no_alert_payload, as: :json
        json_response = JSON.parse(response.body)
        assert_equal json_response, {}.as_json
      end

      test "returns_401_on_invalid_api_key" do
        post api_v1_notifications_path, headers: { "Authorization" => "Fake" }, params: @no_alert_payload, as: :json
        assert_response :unauthorized
      end

      test "returns_401_on_inactive_api_key" do
        post api_v1_notifications_path, headers: { "Authorization" => @inactive_api_key }, params: @no_alert_payload, as: :json
        assert_response :unauthorized
      end
    end 
  end
end

