require 'rails_helper'
require 'faker'

RSpec.describe Api::V1::UsersController do
  let(:route) { '/api/v1/users' }
  let(:params) do
    { user: { 
        name: Faker::Name.name,
        email: Faker::Internet.free_email,
        password: Faker::Internet.password(8) } }
  end

  describe 'POST #create' do
    context 'when fields are ok' do
      it 'creates a new user' do
        post route, params
        body = JSON.parse(response.body)

        expect(response.status).to eq(200)
        expect(body['email']).to eq(params[:user][:email])
        expect(body['user_id']).to be_kind_of(Fixnum)
        expect(body['access_token']).to be_kind_of(String)
        expect(body['access_token'].size).to be(40)
      end
    end

    context 'when validation fails' do
      %w(email password name).each do |field|
        it 'is invalid without email' do
          params[:user][field.to_sym] = nil
          post route, params
          body = JSON.parse(response.body)

          expect(response.status).to eq(422)
          expect(body['message']).to eq('Unprocessable entity')
          expect(body['errors'].first).to eq("#{field.titleize} can't be blank")
        end
      end

      it 'is invalid without a proper email address' do
        params[:user][:email] = 'tiagopog'
        post route, params
        body = JSON.parse(response.body)

        expect(response.status).to eq(422)
        expect(body['message']).to eq('Unprocessable entity')
        expect(body['errors'].first).to eq("Email is not a valid email")
      end

      it 'is invalid if the email is already in use' do
        2.times { post route, params }
        body = JSON.parse(response.body)
        
        expect(response.status).to eq(422)
        expect(body['message']).to eq('Unprocessable entity')
        expect(body['errors'].first).to eq('Email has already been taken')
      end
    end
  end
end
