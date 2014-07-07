require 'rails_helper'

RSpec.describe Session, type: :model do
  subject(:session) { FactoryGirl.create(:session) }

  context 'when the object is valid' do
    it { expect(session).to be_valid }
    it { expect(session.user).to be_kind_of(User) }
    it { expect(session.access_token).to be_kind_of(String) }
    it { expect(session.access_token.size).to be(40) }
    it { expect(session.expires_at).to be > Time.zone.now }
  end

  context 'when validating its data' do
    it 'is invalid without belonging to an user' do
      expect { FactoryGirl.create(:session, user: nil) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe '.authenticate' do
    context 'when session is valid' do
      it 'authenticates the session' do
        expect(Session.authenticate(session.access_token)).to be_kind_of(Session)
      end
    end

    context 'when session is invalid' do
      subject(:expired_session) { FactoryGirl.create(:expired_session) }

      it 'does not authenticates an expired session' do
        expect(Session.authenticate(expired_session.access_token)).to be_nil
      end

      it 'does not authenticates an invalid access token' do
        expect(Session.authenticate('foo')).to be_nil
      end
    end
  end

  describe '.access_token' do
    let(:access_token) { Session.access_token('foobar') }

    it { expect(access_token).to be_kind_of(String) }
    it { expect(access_token.size).to be(40) }
  end
end
