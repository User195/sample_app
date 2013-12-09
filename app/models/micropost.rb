class Micropost < ActiveRecord::Base
  # Доступные для изменени аттрибуты
  attr_accessible :content
  # связи micropost - user
  belongs_to :user

  # Валидация user_id на наличие
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 } 
  # DESC - в обратном порядке
  default_scope order: 'microposts.created_at DESC'

end
