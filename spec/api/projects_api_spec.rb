require 'rails_helper'

RSpec.describe Api::V1::ProjectsController do
  let(:user) { FactoryGirl.create(:user_with_projects) }
  let(:project) { user.projects.first }
  let(:params) { project_params }
  let(:route) { '/api/v1/projects' }
  let(:route_with_id) { "#{route}/#{project.slug}" }
  let(:foobar_route) { "#{route}/foobar" }

  shared_context 'when request is not authenticated' do
    it 'fails and returns an error code/message' do
      get route
      expect(response.status).to eq(401)
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
        get route, nil, auth_header(user)
        
        expect(response.status).to be(200)
        expect(json['projects']).to be_truthy
      end
    end
  end

  describe 'POST #create' do
    include_context 'when request is not authenticated'

    context 'when request is authenticated' do
      context 'validation has not succeeded' do
        it 'is invalid without params' do
          post route, nil, auth_header(user)
          expect(response.status).to be(400)
        end

        it 'is invalid without a name' do
          params[:project][:name] = ''
          post route, params, auth_header(user)
          check_validation_error(response, "Name can't be blank")
        end
      end

      context 'validation has succeeded' do
        it 'creates a new project' do
          post route, params, auth_header(user)
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
          get route_with_id, nil, auth_header(user)

          expect(response.status).to be(200)
          
          expect(json['project']['id']).to be_truthy
          expect(json['project']['slug']).to eq(project.slug)
          
          expect(json['project']['tasks']).to be_truthy
          expect(json['project']['tasks'][0]['name']).to be_kind_of(String)
          expect(json['project']['tasks'][0]['project_id']).to eq(project.id)
        end
      end

      context 'when project is not found' do
        it 'return an error message' do
          get foobar_route, nil, auth_header(user)
          expect(response.status).to be(404)
        end
      end
    end
  end

  describe 'PATCH #update' do
    include_context 'when request is not authenticated'

    context 'when request is authenticated' do
      context 'validation has not succeeded' do
        it 'is invalid without finding the project' do
          patch foobar_route, nil, auth_header(user)
          expect(response.status).to be(400)
        end

        it 'is invalid without a name' do
          params[:project][:name] = ''
          patch route_with_id, params, auth_header(user)
          check_validation_error(response, "Name can't be blank")
        end
      end

      context 'validation has succeeded' do
        it 'updates the project' do
          patch route_with_id, params, auth_header(user)
          expect(response.status).to be(204)
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    include_context 'when request is not authenticated'

    context 'when request is authenticated' do
      context 'when project is found' do
        it 'removes the project' do
          delete route_with_id, nil, auth_header(user)
          expect(response.status).to be(204)
        end
      end

      context 'when project is not found' do
        it 'returns an error message' do
          delete foobar_route, nil, auth_header(user)
          expect(response.status).to be(400)
        end
      end
    end
  end
end