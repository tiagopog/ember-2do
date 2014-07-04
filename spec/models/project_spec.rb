require 'rails_helper'

RSpec.describe Project, type: :model do
  context 'when the object is valid' do
    subject(:project) { FactoryGirl.create(:project) }
    
    it { expect(project).to be_valid }
  end
end
