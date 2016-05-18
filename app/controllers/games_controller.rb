class GamesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update]

  def new
    @game = Game.new
  end

  def create
    @game = Game.create(game_params.merge(white_player_id: current_user.id, state: "open"))
    if @game.persisted?
      redirect_to game_path(@game)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show 
    @game = Game.find(params[:id])
    rescue ActiveRecord::RecordNotFound
    render text: 'Game Not Found', status: :not_found
  end

  def update 
    game = Game.find(params[:id])
    game.update_attributes(black_player_id: current_user.id)
    redirect_to game_path(game)
  end

  private

  def game_params
    params.require(:game).permit(:name)
  end
end

