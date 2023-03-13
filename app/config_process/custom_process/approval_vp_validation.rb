module CustomProcess
  class ApprovalVpValidation
    def main(params)
      params[:form]
      params[:current_user]
      params[:workflow_id]

      if params[:form][:approvalVp] == 'Approve'
        task = Task.find_by(id: params[:task_id])
        task.status = 'HIDE'
        task.save
      else

        # reset current task
        current_task = Task.find_by(id: params[:task_id])
        current_task.form_data = {}
        current_task.status = 'SHOW'
        current_task.save
        # send back value


        send_back_to(
          'Request Form',
          params[:workflow_id],
          params[:task_id],
          current_task,
          params[:form][:rejectReason]
        )



        # is_execute = false
        # Task.where(workflow_id: params[:workflow_id]).order(id: 'desc').each do |task|
        #   if task.id == params[:task_id]
        #     is_execute = true
        #     next
        #   end

        #   next unless is_execute

        #   task.status = 'SHOW'
        #   if task.config_task_id == 1
        #     config_task = ConfigTask.find_by(id: current_task.config_task_id)
        #     task.notes = "Reject from #{config_task.name} | #{params[:form][:rejectReason]}"
        #     task.save
        #     break
        #   else
        #     task.form_data = {}
        #   end
        #   task.save
        # end
      end
    end

    def send_back_to(target_task_name, workflow_id, task_id, current_task, reject_reason)
      is_execute = false
      Task.where(workflow_id:).order(id: 'desc').each do |task|
        if task.id == task_id
          is_execute = true
          next
        end

        next unless is_execute

        task.status = 'SHOW'
        config_task = ConfigTask.find_by(id: task.config_task_id)
        if config_task.name == target_task_name
          config_task = ConfigTask.find_by(id: current_task.config_task_id)
          task.notes = "Reject from #{config_task.name} | #{reject_reason}"
          task.save
          break
        else
          task.form_data = {}
        end
        task.save
      end
    end
    
  end
end
