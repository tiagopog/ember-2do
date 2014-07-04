require 'rails_helper'

RSpec.describe User, type: :model do
  let(:gravatar_regex) { %r{http://www.gravatar.com/avatar/\w+}i }
  let(:image_regex) { %r{(^http{1}[s]?://([w]{3}\.)?.+\.(jpg|jpeg|png|gif)(\?.+)?$)}i }

  context 'when the object is valid' do
    subject(:user) { FactoryGirl.create(:user) }
    
    it { expect(user).to be_valid }
    it { expect(user.avatar_url).to match image_regex }
  end

  context 'when a required field is empty' do
    it 'is invalid without a name' do
      expect(FactoryGirl.build(:user, name: nil)).to_not be_valid
    end

    it 'is invalid without an email' do
      expect(FactoryGirl.build(:user, email: nil)).to_not be_valid
    end
  end
  
  context 'when email is not consistent' do
    let(:emails) { ['tiago@gmail.com', 'tiago','tiago@gmail', 'tiago.com'] } 
    
    it 'can not allow invalid email adresses' do
      emails[1..-1].each do |email|
        expect(FactoryGirl.build(:user, email: email)).to_not be_valid
      end
    end
    
    it 'is invalid if email is already in use' do
      create_user = -> { FactoryGirl.create(:user, email: emails[0]) }
      expect { 2.times { create_user.call } }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe '#avatar' do
    context 'when avatar_url is set' do
      subject(:user) { FactoryGirl.build(:user) }

      it { expect(user.avatar.is_a?(String)).to eq(true) }
      it { expect(user.avatar).to match image_regex }
    end

    context 'when avatar_url is not set' do
      subject(:user) { FactoryGirl.build(:user, avatar_url: nil) }

      it { expect(user.avatar.is_a?(String)).to eq(true) }
      it 'gets the image from Gravatar' do
        expect(user.avatar).to match gravatar_regex
      end
    end
  end

  describe '#gravatar' do
    it 'gets the image from Gravatar' do
      expect(FactoryGirl.build(:user).gravatar).to match gravatar_regex
    end
  end
end
