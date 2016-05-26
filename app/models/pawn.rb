class Pawn < Piece
  def valid_move?(new_rank, new_file)
    rank_diff = new_rank - rank
    file_diff = new_file - file

    return false if is_move_malformed?(new_rank, new_file) || is_move_obstructed?(new_rank, new_file)

    if color == "white"
      correct_direction = 1
      starting_rank = 2
    else
      correct_direction = -1
      starting_rank = 7
    end
    # Standard pawn move
    return true if rank_diff == correct_direction && file_diff == 0
    # Double move
    return true if rank == starting_rank && rank_diff == 2 * correct_direction && file_diff == 0
    # Capture move
    return true if rank_diff == correct_direction && file_diff.abs == 1 && capture_move?(new_rank, new_file)
    # En passant capture
    return true if rank_diff == correct_direction && file_diff.abs == 1 && game.pieces.find_by(rank: rank, file: new_file, en_passant: true)
    
    false
  end

  def image
    if color == 'white'
      return '&#9817;'
    else
      return '&#9823;'
    end
  end
end
