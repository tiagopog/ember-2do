require 'rails_helper'

RSpec.describe Api::V1::TasksController do
  let(:user) { FactoryGirl.create(:user_with_projects) }
  let(:access_token) { user.access_token }
  let(:project) { user.projects.first }
  let(:task) { project.tasks.first }
  let(:params) { task_params }
  let(:route) { "/api/v1/projects/#{project.id}/tasks" }
  let(:route_with_id) { "#{route}/#{task.id}" }
  let(:not_found_route) { "#{route}/9999" }
  
  shared_context 'when request is not authenticated' do
    it 'fails and returns an error code/message' do
      get route
      expect(response.status).to eq(401)
      expect(json['message']).to eq(http_error_msg[401])
    end
  end

  def check_task(done = false)
    expect(response.status).to be(200)
    %w(id project_id name description priority).each do |e|
      expect(json['task'][e]).to be_truthy
      expect(json['task']['done']).to be(done)
    end
  end

  describe 'GET #index' do
    include_context 'when request is not authenticated'

    context 'when request is authenticated' do
      context 'when no filter is applied' do
        it 'returns the list of tasks owned by the current user' do
          get route, nil, auth_header(access_token)
          
          expect(response.status).to be(200)
          expect(json['project']).to be_truthy
          expect(json['tasks']).to be_truthy
          expect(json['tasks'].size).to be > 0
        end
      end

      context 'when it filters by undone tasks' do
        it 'returns the list of tasks owned by the current user' do
          get "#{route}/done:false", nil, auth_header(access_token)
          
          expect(response.status).to be(200)
          expect(json['project']).to be_truthy
          expect(json['tasks'][0]['done']).to be(false)
        end

        it 'returns an error message with no task found' do
          get "#{route}/done:true", nil, auth_header(access_token)
          
          expect(response.status).to be(404)
          expect(json['message']).to eq(http_error_msg[404])
        end
      end
    end
  end

  describe 'POST #create' do
    include_context 'when request is not authenticated'

    context 'when request is authenticated' do
      context 'validation has not succeeded' do
        it 'is invalid without params' do
          post route, nil, auth_header(access_token)
          expect(response.status).to be(400)
          expect(json['message']).to eq(http_error_msg[400])
        end

        it 'is invalid without a name' do
          params[:task][:name] = ''
          post route, params, auth_header(access_token)
          check_validation_error(response, http_error_msg[422], "Name can't be blank")
        end
      end

      context 'validation has succeeded' do
        it 'creates a new project' do
          post route, params, auth_header(access_token)
          check_task
        end
      end
    end
  end

  describe 'GET #show' do
    include_context 'when request is not authenticated'

    context 'when request is authenticated' do
      context 'when tasks is found' do
        it 'loads the data from a given project' do
          get route_with_id, nil, auth_header(access_token)
          check_task          
        end
      end

      context 'when task is not found' do
        it 'return an error message' do
          get not_found_route, nil, auth_header(access_token)
          expect(response.status).to be(404)
          expect(json['message']).to eq(http_error_msg[404])
        end
      end
    end
  end

  describe 'PATCH #update' do
    include_context 'when request is not authenticated'

    context 'when request is authenticated' do
      context 'validation has not succeeded' do
        it 'is invalid without finding the task' do
          patch not_found_route, nil, auth_header(access_token)
          expect(response.status).to be(400)
          expect(json['message']).to eq(http_error_msg[400])
        end

        it 'is invalid without a name' do
          params[:task][:name] = ''
          patch route_with_id, params, auth_header(access_token)
          check_validation_error(response, http_error_msg[422], "Name can't be blank")
        end
      end

      context 'validation has succeeded' do
        it 'creates a new task' do
          patch route_with_id, params, auth_header(access_token)
          check_task
          %w(name description done priority).each do |e|
            expect(json['task'][e]).to_not eq(task_params[:task][e.to_sym])
          end
        end
      end
    end 
  end

  describe 'PATCH #done' do
    include_context 'when request is not authenticated'

    context 'when request is authenticated' do
      context 'validation has not succeeded' do
        it 'is invalid without finding the task' do
          patch "#{not_found_route}/done", nil, auth_header(access_token)
          expect(response.status).to be(400)
          expect(json['message']).to eq(http_error_msg[400])
        end
      end

      context 'validation has succeeded' do
        it 'sets task as done/undone' do
          patch "#{route_with_id}/done", nil, auth_header(access_token)
          expect(json['task']['done']).to be(!task.done)
        end
      end
    end 
  end

  describe 'DELETE #destroy' do
    include_context 'when request is not authenticated'

    context 'when request is authenticated' do
      context 'when task is found' do
        it 'removes the task' do
          delete route_with_id, nil, auth_header(access_token)
          check_task
        end
      end

      context 'when task is not found' do
        it 'returns an error message' do
          delete not_found_route, nil, auth_header(access_token)
          expect(response.status).to be(404)
          expect(json['message']).to eq(http_error_msg[404])
        end
      end
    end
  end
end