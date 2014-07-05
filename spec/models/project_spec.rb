require 'rails_helper'

RSpec.describe Project, type: :model do
  subject(:project) { FactoryGirl.create(:project) }

  context 'when the object is valid' do
    it { expect(project).to be_valid }
    it { expect(project.name).to be_kind_of(String) }
    
    it 'has the slug scoped by author' do
      create_project = lambda { |id| FactoryGirl.create(:project,  user_id: id) }
      expect { 2.times { |i| create_project.call(i + 1) } }.to_not raise_error
    end
    
    it 'has many tasks' do
      expect(FactoryGirl.create(:project_with_tasks).tasks.size).to eq(3)
    end
  end

  context 'when validating its data' do
    it 'is invalid without a name' do
      expect(FactoryGirl.build(:project, name: nil)).to_not be_valid
    end

    it 'is invalid if the slug field is not unique for a given user' do
      create_project = -> { FactoryGirl.create(:project, slug: 'foobar', user_id: 1) }
      expect { 2.times { create_project.call } }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'sets a new slug when one tries to set it as empty' do
      expect(FactoryGirl.create(:project, slug: nil).slug).to_not be_blank
    end

    it 'is invalid without an author' do
      expect { FactoryGirl.create(:project, author: nil) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
