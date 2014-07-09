require 'rails_helper'

RSpec.describe User, type: :model do
  subject(:user) { FactoryGirl.create(:user) }
  let(:gravatar_regex) { %r{http://www.gravatar.com/avatar/\w+}i }
  let(:image_regex) { %r{(^http{1}[s]?://([w]{3}\.)?.+\.(jpg|jpeg|png|gif)(\?.+)?$)}i }

  context 'when the object is valid' do
    it { expect(user).to be_valid }
    it { expect(user.name).to be_kind_of(String) }
    it { expect(user.email).to be_kind_of(String) }
    it { expect(user.token).to be_kind_of(String) }
    it { expect(user.token.size).to be(40) }
    it { expect(user.avatar_url).to match image_regex }
  end

  context 'when they have projects and tasks' do
    subject(:user) { FactoryGirl.create(:user_with_projects) }
    
    it 'has many project' do
      expect(user.projects.size).to eq(3)
    end

    it 'has many tasks through a project' do
      expect(user.projects.first.tasks.size).to eq(3)
    end
  end

  context 'when a required field is empty' do
    it 'is invalid without a name' do
      expect(FactoryGirl.build(:user, name: nil)).to_not be_valid
    end

    it 'is invalid without an email' do
      expect(FactoryGirl.build(:user, email: nil)).to_not be_valid
    end

    it 'is invalid without a password' do
      expect(FactoryGirl.build(:user, password: nil)).to_not be_valid
    end
    
    it 'is invalid with a too short password' do
      expect(FactoryGirl.build(:user, password: 'foo')).to_not be_valid
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

  describe '.authenticate' do
    before(:all) do 
      User.create(name: 'Tiago', email: 'tiagopog@gmail.com', password: 'foobar')
    end

    it 'finds the user if their credentials are ok' do
      expect(User.authenticate('tiagopog@gmail.com', 'foobar')).to be_kind_of(User)
    end

    it 'does not find the user if their credentials are wrong' do
      expect(User.authenticate('tiago@gmail.com.br', 'fooba')).to be(nil)
    end
  end

  describe '.auth_token' do
    let(:token) { User.auth_token('tiagopog@gmail.com', 'foobar') }

    it { expect(token).to be_kind_of(String) }
    it { expect(token.size).to be(40) }
  end

  describe '#avatar' do
    context 'when avatar_url is set' do
      let(:avatar) { user.avatar }
      
      it { expect(avatar).to be_kind_of(String) }
      it { expect(avatar).to match image_regex }
    end

    context 'when avatar_url is not set' do
      let(:avatar) { FactoryGirl.build(:user, avatar_url: nil).avatar }

      it { expect(avatar).to be_kind_of(String) }
      it { expect(avatar).to match gravatar_regex }
    end
  end

  describe '#gravatar' do
    it 'gets the image from Gravatar' do
      expect(user.gravatar).to match gravatar_regex
    end
  end

  describe '#access_token' do
    context 'when creates/finds a valid session' do
      let(:access_token) { user.access_token } 
      
      it { expect(access_token).to be_kind_of(String) }
      it { expect(access_token.size).to be(40) }
    end
  end
end
