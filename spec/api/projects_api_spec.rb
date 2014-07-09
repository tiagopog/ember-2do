require 'rails_helper'

RSpec.describe Api::V1::ProjectsController do
  let(:user) { FactoryGirl.create(:user_with_projects) }
  let(:access_token) { user.access_token }
  let(:project) { user.projects.first }
  let(:params) { project_params }
  let(:route) { '/api/v1/projects' }
  let(:route_with_id) { "#{route}/#{project.slug}" }
  let(:foobar_route) { "#{route}/foobar" }

  shared_context 'when request is not authenticated' do
    it 'fails and returns an error code/message' do
      get route
      expect(response.status).to eq(401)
      expect(json['message']).to eq(http_error_msg[401])
    end
  end

  def check_project
    expect(response.status).to be(200)
    %w(id user_id name slug).each do |e|
      expect(json['project'][e]).to be_truthy
    end
  end

  describe 'GET #index' do
    include_context 'when request is not authenticated'

    context 'when request is authenticated' do
      it 'returns the list of projects owned by the current user' do
        get route, nil, auth_header(access_token)
        
        expect(response.status).to be(200)
        
        expect(json['user']['email']).to eq(user[:email])
        expect(json['projects']).to be_truthy
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
          params[:project][:name] = ''
          post route, params, auth_header(access_token)
          check_validation_error(response, http_error_msg[422], "Name can't be blank")
        end
      end

      context 'validation has succeeded' do
        it 'creates a new project' do
          post route, params, auth_header(access_token)
          check_project
        end
      end
    end
  end

  describe 'GET #show' do
    include_context 'when request is not authenticated'

    context 'when request is authenticated' do
      context 'when project is found' do
        it 'loads the data from a given project' do
          get route_with_id, nil, auth_header(access_token)

          expect(response.status).to be(200)
          
          expect(json['project']['id']).to be_truthy
          expect(json['project']['slug']).to eq(project.slug)
          
          expect(json['tasks']).to be_truthy
          expect(json['tasks'][0]['name']).to be_kind_of(String)
          expect(json['tasks'][0]['project_id']).to eq(project.id)
        end
      end

      context 'when project is not found' do
        it 'return an error message' do
          get foobar_route, nil, auth_header(access_token)
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
        it 'is invalid without finding the project' do
          patch foobar_route, nil, auth_header(access_token)
          expect(response.status).to be(400)
          expect(json['message']).to eq(http_error_msg[400])
        end

        it 'is invalid without a name' do
          params[:project][:name] = ''
          patch route_with_id, params, auth_header(access_token)
          check_validation_error(response, http_error_msg[422], "Name can't be blank")
        end
      end

      context 'validation has succeeded' do
        it 'creates a new project' do
          patch route_with_id, params, auth_header(access_token)
          check_project
          expect(json['project']['slug']).to_not eq(project.slug)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    include_context 'when request is not authenticated'

    context 'when request is authenticated' do
      context 'when project is found' do
        it 'removes the project' do
          delete route_with_id, nil, auth_header(access_token)
          check_project
        end
      end

      context 'when project is not found' do
        it 'returns an error message' do
          delete foobar_route, nil, auth_header(access_token)
          expect(response.status).to be(422)
          expect(json['message']).to eq(http_error_msg[422])
        end
      end
    end
  end
end