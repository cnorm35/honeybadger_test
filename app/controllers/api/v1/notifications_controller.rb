module Api
  module V1
    class NotificationsController < BaseController
      def create
        render json: {}, status: :ok
      end
    end
  end
end
