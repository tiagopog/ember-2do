class Session < ActiveRecord::Base
  belongs_to :user

  validates :user, presence: true

  before_create :tokenize

  class << self
    def authenticate(access_token)
      where('access_token = ? AND expires_at > ?', 
            access_token, 
            Time.zone.now).first
    end

    def access_token(user_token)
      Digest::SHA1.hexdigest([
        Time.zone.now, 
        user_token, 
        Rails.application.secrets.secret_key_base].join(':'))
    end
  end
  
  private

  def tokenize
    self[:access_token] = Session.access_token(self.user.token)
    self[:expires_at] = 24.hours.from_now
  end  
end
