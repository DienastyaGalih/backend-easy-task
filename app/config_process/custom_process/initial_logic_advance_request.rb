module CustomProcess
  class InitialLogicAdvanceRequest
    # def main(logged_user_id, work_flow_id)
    def main(params)
      work_flow_id = params[:work_flow_id]
      logged_user_id = params[:logged_user][:id]
      task = Task.where(workflow_id: work_flow_id, config_task_id: 1).first
      task.assignee_user_id = logged_user_id
      task.save
    end
  end
end
