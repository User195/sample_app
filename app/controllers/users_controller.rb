class UsersController < ApplicationController
  # ограничиваем воздействия предфильтра
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: [:destroy]
  before_filter :signed_in_user_for_new_and_create, only: [:create, :new]
  def index
    # пагинация списка пользователей
    @users = User.paginate(page: params[:page])
  end
  def new
  	@user = User.new
  end
  def show
  	@user = User.find(params[:id])
    # Пагинация списка сообщений
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  def create
  	@user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  def edit
    # @user = User.find(params[:id])
  end
  def update
    # @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile update"
      # 'входим' пользователя, так как сессия слетает при User.save и нужно получить новую
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  def destroy
    # User.find(params[:id]).destroy
    # flash[:success] = "User destroyed."
    # redirect_to users_url
    
    # Если пытаются удалить пользователя со значением поля admin = true
    # То проиходит редирек в корень
    if User.find(params[:id]).admin?
      redirect_to(root_path)
    else
      User.find(params[:id]).destroy
      flash[:success] = "User destroyed."
      redirect_to users_url
    end
  end

  # Прдефильтр, если sign_in? false, то выскакивает notice и редирект
  private
    def signed_in_user_for_new_and_create
      if signed_in?
        redirect_to root_path
      end
    end
    
    # проверка что пользователь требует свою страницу, а не чужую
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end