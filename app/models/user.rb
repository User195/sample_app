# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
	# Автоматически доступные аттирбуты
  attr_accessible :email, :name, :password, :password_confirmation
  # authenticate
  has_secure_password

  before_save { email.downcase! }
  before_save :create_remember_token
  
  VALID_EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  # Полная валидация
  validates :name, presence: true,
  		length: { maximum: 50 }
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true
  validates :email,
  		uniqueness: { case_sensitive: false }, 
  		presence: true, 
  		format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }

  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
