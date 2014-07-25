require 'rails_helper'

describe UserSerializer do
  it 'creates special JSON for the API' do
    user = FactoryGirl.create(:user_to_serialize)   
    access_token, serializer = user.access_token, UserSerializer.new(user)
    json_response =
      <<-JSON.gsub(/^\s+\|(\s+)?|\n/, '')
        |{"user":{
        |    "id":999,
        |    "name":"Tiago Guedes",
        |    "email":"foobar@gmail.com",
        |    "avatar_url":"http://gravatar.com/foobar.jpg",
        |    "created_at":"2014-07-23T14:04:00.255Z",
        |    "access_token":"#{access_token}"
        |  }
        |}
      JSON

    expect(serializer.to_json).to eq(json_response)
  end
end