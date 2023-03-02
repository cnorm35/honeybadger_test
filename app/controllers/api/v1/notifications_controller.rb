module Api
  module V1
    class NotificationsController < BaseController
      def create
        puts "sending alert to Slack" if spam_report?
        render json: { slack_message: slack_payload }, status: :created
      end

      private

      def notification_request_type
        params[:Type]
      end

      def to_email_address
        params[:Email]
      end

      def from_email_address
        params[:From]
      end

      def description
        params[:Description]
      end

      def spam_report?
        notification_request_type == "SpamNotification"
      end

      def slack_payload
        "SPAM EMAIL ---- #{to_email_address} - #{description}"
      end
    end
  end
end
