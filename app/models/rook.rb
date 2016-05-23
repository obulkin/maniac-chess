class Rook < Piece
  def valid_move?(new_rank, new_file)
    if !is_move_malformed?(new_rank, new_file) && (rank == new_rank || file == new_file) && !is_move_obstructed?(new_rank, new_file)
      true
    else
      false
    end
  end

  def image 
    if color == 'white'
      return '&#9814;'
    else
      return '&#9820;'
    end
  end
end


