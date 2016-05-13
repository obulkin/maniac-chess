class Rook < Piece
    def valid_move?(new_rank, new_file)
      if !is_move_malformed?(new_rank, new_file) && (horizontal_move?(new_rank, new_file) || vertical_move?(new_rank, new_file)) && !is_move_obstructed?(new_rank, new_file)
        true
      else
        false
    end
  end
end


