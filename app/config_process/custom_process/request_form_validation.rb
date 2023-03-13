module CustomProcess
  class RequestFormValidation
    def main(params)
        params[:form]
        params[:current_user]
        # validation v1 v2 v3

        #  calculate assign task
        total_anggaran=params[:form][:totalAnggaran].to_i
        if total_anggaran <= 10000000
            show_task('Approval Manager',params[:workflow_id])
            assign_to_task('Approval Manager',params[:workflow_id],get_manager_id(params[:current_user]))

            hide_task('Approval Head',params[:workflow_id])
            hide_task('Approval Vp',params[:workflow_id])
        elsif total_anggaran <= 25000000

            show_task('Approval Manager',params[:workflow_id])
            assign_to_task('Approval Manager',params[:workflow_id],get_manager_id(params[:current_user]))

            show_task('Approval Head',params[:workflow_id])
            assign_to_task('Approval Head',params[:workflow_id],get_head_id(params[:current_user]))

            hide_task('Approval Vp',params[:workflow_id])

        elsif total_anggaran <= 100000000
            show_task('Approval Manager',params[:workflow_id])
            assign_to_task('Approval Manager',params[:workflow_id],get_manager_id(params[:current_user]))

            show_task('Approval Head',params[:workflow_id])
            assign_to_task('Approval Head',params[:workflow_id],get_head_id(params[:current_user]))

            show_task('Approval Vp',params[:workflow_id])
            assign_to_task('Approval Vp',params[:workflow_id],get_vp_id(params[:current_user]))
        elsif total_anggaran <= 250000000
            return
        else
            return
        end



        task = Task.find_by(id: params[:task_id])
        task.status = 'HIDE'
        task.save
        # debugger
    #   # puts ''
    #   debugger
    #   # get Request Form data task
    #   task = Task.where(workflow_id: work_flow_id, config_task_id: 1).first
    #   task.assignee_user_id = logged_user_id
    #   task.save
    #   # debugger
    end


    def get_manager_id(user_id)
        return 4
    end

    def get_head_id(user_id)
        return 7
    end

    def get_vp_id(user_id)
        return 8
    end


    def assign_to_task(task_name,work_flow_id,user_id)
        Task.where(workflow_id: work_flow_id).each do |task|
            config_task = ConfigTask.find_by(id: task.config_task_id)
            if config_task.name == task_name
                task.assignee_user_id = user_id
                task.save
                return
            end
        end
    end

    def show_task(task_name, work_flow_id)
        Task.where(workflow_id: work_flow_id).each do |task|
            config_task = ConfigTask.find_by(id: task.config_task_id)
            if config_task.name == task_name
                task.form_data = {}
                task.status = 'SHOW'
                task.save
                return
            end
        end
    end

    def hide_task(task_name, work_flow_id)
        Task.where(workflow_id: work_flow_id).each do |task|
            config_task = ConfigTask.find_by(id: task.config_task_id)
            if config_task.name == task_name
                task.form_data = {}
                task.status = 'HIDE'
                task.save
                return
            end
        end
    end
  end
end
