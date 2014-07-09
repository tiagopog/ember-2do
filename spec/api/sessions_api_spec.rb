require 'rails_helper'

RSpec.describe Api::V1::SessionsController do
  let(:user) { FactoryGirl.create(:user) }
  let(:route) { '/api/v1/sessions' }

  describe 'POST #create' do
    context 'when crendentials are ok' do
      it 'authenticates the user and returns an access token' do
        post route, { email: user.email, password: user.password }
        expect(response.status).to be(200)
        expect(json['message']).to eq('Authentication has succeeded')
        expect(json['access_token']).to be_kind_of(String)
        expect(json['access_token'].size).to be(40)
      end
    end

    context 'when crendentials are invalid' do
      it 'returns an error message' do
        post route, { email: user.email, password: 'foobar' }
        expect(response.status).to be(404)
        expect(json['message']).to eq('Unknown user')
        expect(json['access_token']).to be_nil
      end
    end
  end
end
