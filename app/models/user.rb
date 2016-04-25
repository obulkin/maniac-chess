class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
       
  def games
    Game.where "white_player_id = :user_id OR black_player_id = :user_id", {user_id: id} 
  end
end
