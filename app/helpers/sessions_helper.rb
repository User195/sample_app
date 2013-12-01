module SessionsHelper
	def sign_in(user)
		# Сохраняем кукисы в браузере при Sign_in 20 лет
		cookies.permanent[:remember_token] = user.remember_token
		# Вызывает метод current_user=(user) # без self создалась бы локальная переменная
		self.current_user = user
	end
	# Хранит пользователся user для дальнейшего сипользования
	def current_user=(user)
		@current_user = user
	end
	def current_user
		@current_user ||= User.find_by_remember_token(cookies[:remember_token])
	end
	def signed_in?
		!current_user.nil?
	end
	def sign_out
		self.current_user = nil
		cookies.delete(:remember_token)		
	end
end
