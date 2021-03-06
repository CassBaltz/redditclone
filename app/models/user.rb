# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
require 'bcrypt'
class User < ActiveRecord::Base
  include BCrypt
  attr_reader :password

  has_one(
  :sub,
  :class_name => 'Sub',
  foreign_key: :moderator_id,
  primary_key: :id
  )

  has_many(
  :posts,
  class_name: 'Post',
  foreign_key: :author_id,
  primary_key: :id
  )


  after_initialize :ensure_session_token

  validates :session_token, :username, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :password, length: {minimum: 6, allow_nil: true}

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def self.find_by_credentials(username, password)
    user = User.find_by(username: username)
    return nil if user.nil?
    user.is_password?(password) ? user : nil
  end

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64(16)
    self.save!
    self.session_token
  end

  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64(16)
  end

  def owns_sub(sub_id)
    subs = Sub.find(sub_id)
    self.id == subs.moderator_id
  end
end
