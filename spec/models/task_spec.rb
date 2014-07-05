require 'rails_helper'

RSpec.describe Task, type: :model do
  subject(:task) { FactoryGirl.create(:task) }

  context 'when the object is valid' do
    it { expect(task).to be_valid }
    it { expect(task.name).to be_kind_of(String) }
    it { expect(task.description).to be_kind_of(String) }
    it { expect(task.done).to be_kind_of(FalseClass) }
    it { expect(task.priority).to be_kind_of(String) }

    it 'is undone by default' do
      expect(task.done).to be(false)
    end

    it 'has the default priority set to medium' do
      expect(task.priority).to eq('medium')
    end
  end

  context 'when validating its data' do
    it 'is invalid without a name' do
      expect { FactoryGirl.create(:task, name: nil) }.to raise_error(ActiveRecord::RecordInvalid)
    end
    
    it 'is invalid without a project' do
      expect { FactoryGirl.create(:task, project: nil) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
