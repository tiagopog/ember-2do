require 'rails_helper'
require 'faker'

RSpec.describe Api::V1::UsersController do
  let(:route) { '/api/v1/users' }
  let(:access_token) { FactoryGirl.create(:session).access_token }

  describe 'POST #create' do
    context 'when fields are ok' do
      it 'creates a new user' do
        params = {}
        params[:user] = { access_token: access_token,
                          name: Faker::Name.name,
                          email: Faker::Internet.free_email,
                          password: Faker::Internet.password(8) }
        post route, params
        body = JSON.parse(response.body)

        expect(response.status).to eq(200)
        expect(body['email']).to eq(params[:user][:email])
        expect(body['user_id']).to be_kind_of(Fixnum)
        expect(body['access_token']).to be_kind_of(String)
        expect(body['access_token'].size).to be(40)
      end
    end    
  end
end
