module Api
  module V1
    class NotificationsController < BaseController
      def create
        render json: {}, status: :created
      end
    end
  end
end
