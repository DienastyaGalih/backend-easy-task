module Api
  module V3
    class TaskActionController < Api::V3::ApiController
      skip_before_action :verify_authenticity_token

      def submit
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
        headers['Access-Control-Request-Method'] = '*'
        headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'

        task = Task.find_by(id: params['task_id'])
        task.form_data = params['form']

        if task.assignee_user_id.to_s != params['logged_user_id']
            return render json: {
                isSuccess: false,
                message: 'You are not asssignee this task'
              }
        end

        config_task = ConfigTask.find_by(id: task.config_task_id)

        # is stop validation
        tasks_order_ascending = Task.where(workflow_id: task.workflow_id).order(id: 'asc')

        tasks_order_ascending.each do |t|
          break if t.id == task.id

          tc = ConfigTask.find_by(id: t.config_task_id)
          if t.status == 'SHOW' && tc.is_stop == true
            return render json: {
              isSuccess: false,
              message: 'Complete before stopable task'
            }
          end
        end


        # a. logic_validation
        # save data to database
        # b. logic_validation

        # run logic validation
        if config_task.logic_validation.nil?
          task.status = 'HIDE'
          task.save
        else
          task.save
          ProcessCaller.new.call(
            config_task.logic_validation, {
              form: params['form'],
              logged_user: {
                id: params['logged_user_id']
              },
              task_id: task.id,
              workflow_id: task.workflow_id
            }
          )
        end
        # debugger

        # debugger
        # add validation logic
        # save data form to database
        # render json: {
        #   status: 'success',
        #   data: '',
        #   message: '',
        #   meta: {
        #     pagination: {
        #       page: 20,
        #       limit: 1,
        #       total_data: job_types.count,
        #       total_page: 1
        #     }
        #   }
        # }
      end
    end
  end
end
