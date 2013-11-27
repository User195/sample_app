class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
  	# Здесь используется Rails метод add_index 
  	# для добавления индекса на столбце email таблицы users. 
  	add_index :users, :email, unique: true
  end
end
