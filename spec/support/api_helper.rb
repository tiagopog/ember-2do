module ApiHelper
  def user_params
    { user: { 
        name: Faker::Name.name,
        email: Faker::Internet.free_email,
        password: Faker::Internet.password(8) } }
  end

  def project_params
    { project: { name: Faker::Name.name } }
  end

  def auth_header(access_token)
    { 'Authorization' => "Token token=#{access_token}" }
  end

  def check_response(response, status, msg)
    expect(response.status).to eq(status)
    expect(json['message']).to eq(msg)
  end

  def check_validation_error(response, http_error_msg, error_msg)
    check_response(response, 422, http_error_msg)
    expect(json['errors'].first).to eq(error_msg)
  end
end