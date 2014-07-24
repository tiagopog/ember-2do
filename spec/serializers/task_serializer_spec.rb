require 'rails_helper'

describe TaskSerializer do
  it 'creates special JSON for the API' do
    serializer = TaskSerializer.new(FactoryGirl.create(:task_to_serialize))
    json_response =
      <<-JSON.gsub(/^\s+\|(\s+)?|\n/, '')
        |{"task":{
        |    "id":999,
        |    "name":"Do it now",
        |    "description":"Lorem ipsum dolor sit amet.",
        |    "done":false,
        |    "priority":"medium",
        |    "created_at":"2014-07-23T00:13:58.749Z",
        |    "project_id":999
        |  }
        |}
      JSON

    expect(serializer.to_json).to eq(json_response)
  end
end