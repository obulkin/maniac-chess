class Queen < Piece
  def valid_move?(new_rank, new_file)
    return false if is_move_malformed?(new_rank, new_file) || is_move_obstructed?(new_rank, new_file)
    
    rank == new_rank || file == new_file || (rank - new_rank).abs == (file - new_file).abs
  end
end
