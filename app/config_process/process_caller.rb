class ProcessCaller
  # def call(function_name, logged_user_id,workflow_id)
  #   ProcessList.new.public_send(function_name, logged_user_id, workflow_id)
  # end
  def call(function_name, params)
    ProcessList.new.public_send(function_name, params)
  end
end
