require 'rails_helper'
require 'faker'

RSpec.describe Api::V1::UsersController do
  let(:params) { user_params }
  let(:route) { '/api/v1/users' }
  let(:http_error_msg) { 'Unprocessable entity' }
  
  describe 'POST #create' do
    context 'when fields are ok' do
      it 'creates a new user' do
        post route, params
        
        expect(response.status).to eq(200)
        expect(json['email']).to eq(params[:user][:email])
        expect(json['user_id']).to be_kind_of(Fixnum)
        expect(json['access_token']).to be_kind_of(String)
        expect(json['access_token'].size).to be(40)
      end
    end

    context 'when validation fails' do
      %w(email password name).each do |field|
        it "is invalid without #{field}" do
          error_msg = "#{field.titleize} can't be blank"
          params[:user][field.to_sym] = nil
          
          post route, params
          check_validation_error(response, http_error_msg, error_msg)
        end
      end

      it 'is invalid without a proper email address' do
        params[:user][:email] = 'tiagopog'
        post route, params
        check_validation_error(response, http_error_msg, 'Email is not a valid email')
      end

      it 'is invalid if the email is already in use' do
        2.times { post route, params }
        check_validation_error(response, http_error_msg, 'Email has already been taken')
      end
    end
  end
end
