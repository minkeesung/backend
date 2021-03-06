class User < ApplicationRecord
  validates :email, :password_digest, presence: true
  # validates :email, uniqueness: true
  # validates :password, length: { minimum: 6, allow_nil: true }
  # validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }

  after_initialize :ensure_session_token

  has_many :projects,
    class_name: :Project,
    foreign_key: :creator_id

  has_many :pledges,
    foreign_key: :backer_id

  attr_reader :password

  def self.find_by_credentials(email, pw)
    user = User.find_by(email: email)
    user && user.is_password?(pw) ? user : nil
  end

  def reset_token
    self.session_token = SecureRandom.urlsafe_base64(16)
    self.save!
    self.session_token
  end

  def password=(pw)
    @password = pw
    self.password_digest = BCrypt::Password.create(pw)
  end

  def is_password?(pw)
    BCrypt::Password.new(self.password_digest).is_password?(pw)
  end

  private

  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64(16)
  end
end
