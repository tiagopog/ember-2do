require 'rails_helper'
require 'faker'

RSpec.describe Api::V1::ProjectsController do
  let(:route) { '/api/v1/projects' }
  # let(:access_token) { FactoryGirl.create(:session).access_token }

  shared_context 'when request is not autenticated' do
    it 'fails and returns an error code/message' do
      get route
      expect(response.status).to eq(401)
      expect(json['message']).to eq('Unauthorized request')
    end
  end

  describe 'GET #index' do
    include_context 'when request is not autenticated'

    context 'when request is autenticated' do
      it 'returns the list of projects owned by the current user' do
      end
    end
  end

  describe 'POST #create' do
    include_context 'when request is not autenticated'
  end

  describe 'GET #show' do
    include_context 'when request is not autenticated'
  end

  describe 'PUT #update' do
    include_context 'when request is not autenticated'
  end

  describe 'DELETE #destroy' do
    include_context 'when request is not autenticated'
  end
end