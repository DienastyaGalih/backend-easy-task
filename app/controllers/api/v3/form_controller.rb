module Api
  module V3
    class FormController < Api::V3::ApiController
      def index
        render json: {}
      end

      def submit
        render json: {
          status: 'success',
          data: '',
          message: '',
          meta: {
            pagination: {
              page: 20,
              limit: 1,
              total_data: job_types.count,
              total_page: 1
            }
          }
        }
      end
    end
  end
end
