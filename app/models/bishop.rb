class Bishop < Piece
  def valid_move?(new_rank, new_file)
    rank_diff = new_rank - rank
    file_diff = new_file - file

    return false if is_move_malformed? new_rank, new_file

    # Proper bishop moves must be diagonal with a slope of 1 or -1
    return false if rank_diff == 0 || file_diff == 0 || rank_diff.abs != file_diff.abs
    
    !is_move_obstructed? new_rank, new_file
  end
end
