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
  # pasword_digest 
  has_secure_password
  # связи user -> microposts
  has_many :microposts, dependent: :destroy # dependent: опция зависимости, destroy - значит что вызовет метод destroy у связанного объекта

  before_save { email.downcase! }
  before_save :create_remember_token
  
  VALID_EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  # Полная валидация

  # проверка на наличие name и длинну не болье 50
  validates :name, presence: true,
  		length: { maximum: 50 }
  # проверка на длинну пароля: минимум 6 символов
  validates :password, length: { minimum: 6 }
  # проверка на наличие повторного пароля
  validates :password_confirmation, presence: true
  # проверка email на: уникальность, наличие, формат ввода test@test.com
  validates :email,
  		uniqueness: { case_sensitive: false }, 
  		presence: true, 
  		format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i }


  def feed
    #
    Micropost.where("user_id = ?", id)
  end


  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
