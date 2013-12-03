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
	def current_user?(user)
		user == current_user
	end
	def signed_in?
		!current_user.nil?
	end
	def sign_out
		self.current_user = nil
		cookies.delete(:remember_token)		
	end
	# Запоминаем текущий URL
	def store_location
		session[:return_to] = request.url
	end
	def redirect_back_or(default)
		# редиректит на store_location, но если
		# session[:return_to] = nil, то default
		redirect_to(session[:return_to] || default)
		# очищает session[:redirect_to]
		session.delete(:return_to)
	end
end
