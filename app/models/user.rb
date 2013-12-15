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
  # Внешний ключ указывается автоматом по шаблону <class>_id
  has_many :microposts, dependent: :destroy # dependent: опция зависимости, destroy - значит что вызовет метод destroy у связанного объекта
  # Здесь явно указываем внешний ключ (foreign_key)
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed # source пререопределяет дефолтные настройки вызова
                                                                       # вместо same_user.followeds будет same_user.followed_users
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy

  has_many :followers, through: :reverse_relationships, source: :follower

  # callbacks
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
    Micropost.from_users_followed_by(self)
  end

  # проверка, существует ли other_user в базе данных 
  def following?(other_user)
    # self опустили
    relationships.find_by_followed_id(other_user.id)
  end

  # метод создание взаимоотношений
  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  # прекращение слежение за пользователями
  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end




  private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
