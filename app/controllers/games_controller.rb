class GamesController < ApplicationController

  def new
    @game = Game.new
  end

  def index
  end

  def create
    @game = Game.create(game_params)
    @game.update_attribute(white_player_id, current_user.id)
    redirect_to root_path
  end

  def show 
    @game = Game.find_by_id(params[:id])
    if @game.blank?
      render text: 'Not Found', status: :not_found
    end
  end

  def update 
    @game = Game.find(params[:id])
    @game.update_attributes(black_player_id: current_user.id)
    redirect_to game_path(@game.id)
  end

  private

  def game_params
    params.require(:game).permit(:name, :black_player_id)
  end
end
