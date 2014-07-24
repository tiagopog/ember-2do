require 'rails_helper'

describe ProjectSerializer do
  it 'creates special JSON for the API' do
    serializer = ProjectSerializer.new(FactoryGirl.create(:project_to_serialize))
    json_response =
      <<-JSON.gsub(/^\s+\|(\s+)?|\n/, '')
        |{"tasks":[{
        |    "id":9999,
        |    "name":"Do it now",
        |    "description":"Lorem ipsum dolor sit amet.",
        |    "done":false,
        |    "priority":"medium",
        |    "created_at":"2014-07-23T00:13:58.749Z",
        |    "project_id":9999
        |  }
        |],
        | "project":{
        |    "id":9999,
        |    "name":"Awesome project!",
        |    "slug":"awesome-project",
        |    "created_at":"2014-07-23T00:13:58.718Z",
        |    "task_ids":[9999]
        |  }
        |}
      JSON

    expect(serializer.to_json).to eq(json_response)
  end
end