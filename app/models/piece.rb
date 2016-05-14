class Piece < ActiveRecord::Base
  validates :type, presence: true, inclusion: {within: ["Pawn", "Rook", "Bishop", "Knight", "Queen", "King"]}
  validates :color, presence: true, inclusion: {within: ["white", "black"]}
  validates :rank, presence: true, inclusion: {within: 1..8}
  validates :file, presence: true, inclusion: {within: 1..8}
  validates :game_id, presence: true

  belongs_to :game

  def user
    color == "white" ? game.white_player : game.black_player
  end

  # Please note that this method does not test whether the move is valid
  def capture_move?(new_rank, new_file)
    color == "white" ? enemy_color = "black" : enemy_color = "white"
    game.pieces.find_by(rank: new_rank, file: new_file, color: enemy_color) ? true : false
  end

  protected
  # This method only checks for obstructions along horizontal, vertical, and diagonal moves. Before calling it,
  # please make sure that the move provided falls into one of these categories and that an obstruction check is
  # actually needed (e.g. the piece isn't a knight, the move is not malformed).
  def is_move_obstructed?(new_rank, new_file)
    current_pieces = game.pieces
    exception_for_capture = ->(offset, peak_offset, piece_at_offset) do
      return true if offset == peak_offset && piece_at_offset.present? && piece_at_offset.first.color != color
      false
    end

    # These are assumed to be diagonal moves along a slope of 1
    if new_rank > rank && new_file > file
      (1..new_rank - rank).each do |offset|
        piece_at_offset = current_pieces.select{|piece| piece.rank == rank + offset && piece.file == file + offset}
        # Exception for an enemy piece in the spot at the end of the move
        next if exception_for_capture.call(offset, new_rank - rank, piece_at_offset)
        return true if piece_at_offset.present?
      end
      false
    elsif new_rank < rank && new_file < file
      (new_rank - rank..-1).each do |offset|
        piece_at_offset = current_pieces.select{|piece| piece.rank == rank + offset && piece.file == file + offset}
        next if exception_for_capture.call(offset, new_rank - rank, piece_at_offset)
        return true if piece_at_offset.present?
      end
      false

    # These are assumed to be diagonal moves along a slope of -1
    elsif new_rank > rank && new_file < file
      (1..new_rank - rank).each do |offset|
        piece_at_offset = current_pieces.select{|piece| piece.rank == rank + offset && piece.file == file - offset}
        next if exception_for_capture.call(offset, new_rank - rank, piece_at_offset)
        return true if piece_at_offset.present?
      end
      false
    elsif new_rank < rank && new_file > file
      (new_rank - rank..-1).each do |offset|
        piece_at_offset = current_pieces.select{|piece| piece.rank == rank + offset && piece.file == file - offset}
        next if exception_for_capture.call(offset, new_rank - rank, piece_at_offset)
        return true if piece_at_offset.present?
      end
      false

    # Vertical moves
    elsif new_rank > rank
      (1..new_rank - rank).each do |offset|
        piece_at_offset = current_pieces.select{|piece| piece.rank == rank + offset && piece.file == file}
        next if exception_for_capture.call(offset, new_rank - rank, piece_at_offset)
        return true if piece_at_offset.present?
      end
      false
    elsif new_rank < rank
      (new_rank - rank..-1).each do |offset|
        piece_at_offset = current_pieces.select{|piece| piece.rank == rank + offset && piece.file == file}
        next if exception_for_capture.call(offset, new_rank - rank, piece_at_offset)
        return true if piece_at_offset.present?
      end
      false

    # Horizontal moves
    elsif new_file > file
      (1..new_file - file).each do |offset|
        piece_at_offset = current_pieces.select{|piece| piece.rank == rank && piece.file == file + offset}
        next if exception_for_capture.call(offset, new_file - file, piece_at_offset)
        return true if piece_at_offset.present?
      end
      false
    elsif new_file < file
      (new_file - file..-1).each do |offset|
        piece_at_offset = current_pieces.select{|piece| piece.rank == rank && piece.file == file + offset}
        next if exception_for_capture.call(offset, new_file - file, piece_at_offset)
        return true if piece_at_offset.present?
      end
      false
    end
  end

  # This method checks if a player tries to move a piece
  # back to the same square after pick up or tries to move
  # a piece outside of the board.
  def is_move_malformed?(new_rank, new_file)
    return true if rank == new_rank && file == new_file
    return true if new_rank < 1 || new_rank > 8
    return true if new_file < 1 || new_file > 8
    false
  end
end
