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
      end

      test "create_returns_204" do
        post api_v1_notifications_path, params: {}, as: :json
        assert_response :created
      end

      test "create_notification_returns_json" do
        post api_v1_notifications_path, params: {}, as: :json
        json_response = JSON.parse(response.body)
        assert_equal Hash.new, json_response
      end

      test "spam_report_sends_new_notification" do
        post api_v1_notifications_path, params: @alert_payload, as: :json
        json_response = JSON.parse(response.body)
        assert_equal json_response, { slack_message: @alert_payload_slack_message }.as_json
      end

      test "bounce_does_not_send_notification" do
      end
    end
  end
end

