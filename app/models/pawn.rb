class Pawn < Piece
  def valid_move?(new_rank, new_file)
    rank_diff = new_rank - rank
    file_diff = new_file - file

    return false if is_move_malformed?(new_rank, new_file) || is_move_obstructed?(new_rank, new_file)

    if color == "white"
      # Standard pawn move
      return true if rank_diff == 1 && file_diff == 0
      # Double move
      return true if rank == 2 && rank_diff == 2 && file_diff == 0
      # Capture move
      return true if rank_diff == 1 && file_diff.abs == 1 && capture_move?(new_rank, new_file)
    else
      return true if rank_diff == -1 && file_diff == 0
      return true if rank == 7 && rank_diff == -2 && file_diff == 0
      return true if rank_diff == -1 && file_diff.abs == 1 && capture_move?(new_rank, new_file)
    end
    false
  end
end
