class User < ActiveRecord::Base
  attr_accessor :password

  has_many :sessions
  has_many :projects, dependent: :destroy
  has_many :tasks, through: :projects

  has_one :access_token, through: :sessions

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, email: true
  validates :password, presence: true, length: { minimum: 6 }, on: :create
  
  before_create :tokenize

  class << self
    def authenticate(email, password)
      find_by(token: auth_token(email, password))
    end

    def auth_token(email, password)
      Digest::SHA1.hexdigest([
        email,
        password,
        Rails.application.secrets.secret_key_base].join(':'))
    end
  end
  
  def avatar; self[:avatar_url] || gravatar end
  
  def gravatar; Gravatar.new(self[:email]).image_url end

  def access_token
    Session.find_or_create(self).access_token
  end

  private

  def tokenize
    self[:token] = User.auth_token(self.email, self.password)
  end
end
