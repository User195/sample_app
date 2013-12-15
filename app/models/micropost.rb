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

  def self.from_users_followed_by(user)
  	# followed_user_id = user.followed_user_ids
    followed_user_ids = "SELECT followed_id FROM relationships
                        WHERE follower_id = :user_id"
  	# where("user_id IN (:followed_user_ids) OR user_id = :user_id",
    #        followed_user_ids: followed_user_ids, user_id: user_id)
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
  end


end
