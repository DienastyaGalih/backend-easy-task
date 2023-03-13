module Api
  module V3
    class WorkFlowController < Api::V3::ApiController
      # entire controller
      # skip_before_action :verify_authenticity_token

      skip_before_action :verify_authenticity_token

      def run_workflow
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
        headers['Access-Control-Request-Method'] = '*'
        headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
        puts params['logged_user_id']
        logged_user_id = params['logged_user_id']

        #  debugger

        config_work_flow_data = ConfigWorkFlow.find_by(id: 1)
        work_flow = WorkFlow.new
        work_flow.config_work_flow_id = config_work_flow_data.id
        work_flow.save!

        ConfigTask.where(config_workflow_id: 1).order(task_order: :asc).each do |config_task|
          task = Task.new
          task.form_data = config_task.form_data
          task.config_task_id = config_task.id
          task.workflow_id = work_flow.id
          # dummy default assignee to logged in user @ani staff
          task.assignee_user_id = nil
          task.status = 'show'
          task.save!
          sleep(0.5)
        end

        # debugger
        ProcessCaller.new.call(
          'initial_logic_advance_request',
          {
            logged_user: {
              id: logged_user_id
            },
            work_flow_id: work_flow.id
          }
        )
      end

      def index
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
        headers['Access-Control-Request-Method'] = '*'
        headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'

        puts params['work_flow_id']

        task_list = []
        work_flow = WorkFlow.find_by(id: params['work_flow_id'])
        config_work_flow = ConfigWorkFlow.find_by(id: work_flow.config_work_flow_id)

        Task.where(workflow_id: work_flow.id).order(id: 'asc').each do |task|
          config_task = ConfigTask.find_by(id: task.config_task_id)
          task_list.push({
                           id: task.id,
                           name: config_task.name,
                           form_ui_schema: config_task.form_ui,
                           form_schema_validation: config_task.form_validation,
                           form_data: task.form_data,
                           logic_validation: config_task.logic_validation,
                           is_stop: config_task.is_stop,
                           assignee_user_id: task.assignee_user_id,
                           assignee_team_id: task.assignee_team_id,
                           action_by_user_id: nil,
                           status: task.status,
                           notes: task.notes
                         })
        end

        render json: {
          work_flow_name: config_work_flow.name,
          task: task_list
        }

        # render json: {
        #   task: [
        #     {
        #       id: 1,
        #       name: 'Request Form',
        #       form_ui_schema: {
        #         "type": 'VerticalLayout',
        #         "elements": [
        #           {
        #             "type": 'Label',
        #             "text": 'Request Form'
        #           },
        #           {
        #             "type": 'Control',
        #             "scope": '#/properties/name'
        #           },
        #           {
        #             "type": 'Control',
        #             "scope": '#/properties/team'
        #           },
        #           {
        #             "type": 'Control',
        #             "scope": '#/properties/projectName'
        #           },
        #           {
        #             "type": 'Group',
        #             "label": 'Project period',
        #             "elements": [
        #               {
        #                 "type": 'HorizontalLayout',
        #                 "label": 'Project period',
        #                 "elements": [
        #                   {
        #                     "type": 'Control',
        #                     "scope": '#/properties/projectStart'
        #                   },
        #                   {
        #                     "type": 'Control',
        #                     "scope": '#/properties/projectEnd'
        #                   }
        #                 ]
        #               }
        #             ]
        #           },
        #           {
        #             "type": 'VerticalLayout',
        #             "elements": [
        #               {
        #                 "type": 'Control',
        #                 "scope": '#/properties/rincianAggaran'
        #               }
        #             ]
        #           },
        #           {
        #             "type": 'VerticalLayout',
        #             "elements": [
        #               {
        #                 "type": 'Control',
        #                 "scope": '#/properties/budgetAllocation'
        #               }
        #             ]
        #           }
        #         ]
        #       },
        #       form_schema_validation: {
        #         "type": 'object',
        #         "required": %w[
        #           name
        #           team
        #           projectName
        #         ],
        #         "properties": {
        #           "name": {
        #             "type": 'string'
        #           },
        #           "team": {
        #             "type": 'string'
        #           },
        #           "projectName": {
        #             "type": 'string'
        #           },
        #           "height": {
        #             "type": 'number'
        #           },
        #           "projectStart": {
        #             "type": 'string',
        #             "format": 'date'
        #           },
        #           "projectEnd": {
        #             "type": 'string',
        #             "format": 'date'
        #           },
        #           "rating": {
        #             "type": 'integer'
        #           },
        #           "committer": {
        #             "type": 'boolean'
        #           },
        #           "address": {
        #             "type": 'object',
        #             "properties": {
        #               "street": {
        #                 "type": 'string'
        #               },
        #               "streetnumber": {
        #                 "type": 'string'
        #               },
        #               "postalCode": {
        #                 "type": 'string'
        #               },
        #               "city": {
        #                 "type": 'string'
        #               }
        #             }
        #           },
        #           "rincianAggaran": {
        #             "type": 'array',
        #             "items": {
        #               "type": 'object',
        #               "properties": {
        #                 "description": {
        #                   "type": 'string'
        #                 },
        #                 "price": {
        #                   "type": 'number'
        #                 },
        #                 "quantity": {
        #                   "type": 'number'
        #                 },
        #                 "nominal": {
        #                   "type": 'number'
        #                 }
        #               }
        #             }
        #           },
        #           "budgetAllocation": {
        #             "type": 'array',
        #             "items": {
        #               "type": 'object',
        #               "properties": {
        #                 "name": {
        #                   "type": 'string'
        #                 },
        #                 "percentage": {
        #                   "type": 'number'
        #                 },
        #                 "productAllocation": {
        #                   "type": 'string',
        #                   "enum": [
        #                     'Ruang Belajar',
        #                     'Robo Guru'
        #                   ]
        #                 },
        #                 "teamBudgetAllocation": {
        #                   "type": 'string',
        #                   "enum": [
        #                     'Web SEO',
        #                     'Enterprise'
        #                   ]
        #                 }
        #               }
        #             }
        #           }
        #         }
        #       },
        #       form_data: {},
        #       logic_validation: {},
        #       is_stop: false,
        #       assignee_user_id: 1,
        #       status: 'hide'
        #     },
        #     {
        #       id: 2,
        #       name: 'Approval Manager',
        #       form_ui_schema: {
        #         "type": 'Control',
        #         "scope": '#/properties/approvalManager',
        #         "options": {
        #           "format": 'radio'
        #         }
        #       },
        #       form_schema_validation: {
        #         "type": 'object',
        #         "properties": {
        #           "approvalManager": {
        #             "type": 'string',
        #             "enum": %w[
        #               Approve
        #               Reject
        #             ]
        #           }
        #         }
        #       },
        #       form_data: {},
        #       logic_validation: {},
        #       is_stop: true,
        #       assignee_user_id: 1,
        #       status: 'show'
        #     },
        #     {
        #       id: 3,
        #       name: 'Approval Head',
        #       form_ui_schema: {
        #         "type": 'Control',
        #         "scope": '#/properties/approvalHead',
        #         "options": {
        #           "format": 'radio'
        #         }
        #       },
        #       form_schema_validation: {
        #         "type": 'object',
        #         "properties": {
        #           "approvalHead": {
        #             "type": 'string',
        #             "enum": %w[
        #               Approve
        #               Reject
        #             ]
        #           }
        #         }
        #       },
        #       form_data: {},
        #       logic_validation: {},
        #       is_stop: true,
        #       assignee_user_id: 1,
        #       status: 'show'
        #     },
        #     {
        #       id: 4,
        #       name: 'Approval Vp',
        #       form_ui_schema: {
        #         "type": 'Control',
        #         "scope": '#/properties/approvalVP',
        #         "options": {
        #           "format": 'radio'
        #         }
        #       },
        #       form_schema_validation: {
        #         "type": 'object',
        #         "properties": {
        #           "approvalVP": {
        #             "type": 'string',
        #             "enum": %w[
        #               Approve
        #               Reject
        #             ]
        #           }
        #         }
        #       },
        #       form_data: {},
        #       logic_validation: {},
        #       is_stop: true,
        #       assignee_user_id: 1,
        #       status: 'show'
        #     }
        #   ]
        # }
      end

      def list
        headers['Access-Control-Allow-Origin'] = '*'
        headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
        headers['Access-Control-Request-Method'] = '*'
        headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'

        data_list = []
        WorkFlow.all.each do |workflow|
          task = Task.where(workflow_id: workflow.id, status: 'show').order(id: 'asc').first
          
          config_work_flow = ConfigWorkFlow.find_by(id: workflow.config_work_flow_id)
          if task.nil?
            data_list.push({
              workflow_id: workflow.id,
              workflow_name: config_work_flow.name,
              last_task_name: 'DONE',
              assignee_user_id: '-',
              assignee_team_id: '-'
            })
          else
            task_config = ConfigTask.find_by(id: task.config_task_id)
            data_list.push({
              workflow_id: workflow.id,
              workflow_name: config_work_flow.name,
              last_task_name: task_config.name,
              assignee_user_id: task.assignee_user_id,
              assignee_team_id: task.assignee_team_id
            })
          end
        end

        render json: data_list
      end
    end
  end
end
