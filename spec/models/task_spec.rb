require 'rails_helper'

RSpec.describe Task, type: :model do
  subject(:task) { FactoryGirl.create(:task) }
  let(:project) { task.project }
  let(:user) { project.author }

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
    
    it 'is invalid without belonging to a project' do
      expect { FactoryGirl.create(:task, project: nil) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe '.filter' do
    context 'when no filter is applied' do
      let(:loaded_tasks) { Task.filter(project.tasks) }

      it { expect(loaded_tasks.size).to eq(1) }
      it { expect(loaded_tasks.first).to be_kind_of(Task) }
    end

    context 'when filtered by tasks which are done' do
      subject(:task) { FactoryGirl.create(:task, done: true) }
      let(:project) { task.project }
      let(:user) { project.author }
      let(:loaded_tasks) { Task.filter(project.tasks, true) }
      let(:tasks_not_found) { Task.filter(project.tasks, false) }
      
      it { expect(loaded_tasks).to be_kind_of(Array) }
      it { expect(loaded_tasks.size).to eq(1) }
      it { expect(loaded_tasks.first).to be_kind_of(Task) }

      it { expect(tasks_not_found).to be_empty }
    end
  end
end
