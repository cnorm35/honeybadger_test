module Api
  module V1
    class BaseController < ApplicationController
      before_action :validate_api_key

      private

      def validate_api_key
        head :unauthorized unless api_key
      end

      def token_from_header
        request.headers.fetch("Authorization", "").split(" ").last
      end

      def api_key
        @_api_key ||= ApiKey.active.find_by(value: token_from_header)
      end

    end
  end
end
