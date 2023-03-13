class ProcessList
  def initial_logic_advance_request(params)
    CustomProcess::InitialLogicAdvanceRequest.new.main(params)
  end

  def request_form_validation(params)
    CustomProcess::RequestFormValidation.new.main(params)
  end

  def approval_manager_validation(params)
    CustomProcess::ApprovalManagerValidation.new.main(params)
  end

  def approval_head_validation(params)
    CustomProcess::ApprovalHeadValidation.new.main(params)
  end

  def approval_vp_validation(params)
    CustomProcess::ApprovalVpValidation.new.main(params)
  end
end
