class Knight < Piece
  def valid_move?(new_rank, new_file)
    rank_diff = new_rank - rank
    file_diff = new_file - file

    return false if is_move_malformed? new_rank, new_file

    # Negation of standard knight moves
    return false if !((rank_diff.abs == 1 && file_diff.abs == 2) || (rank_diff.abs == 2 && file_diff.abs == 1))
    # Obstruction at move destination
    return false if game.pieces.find_by rank: new_rank, file: new_file, color: color

    true
  end
end
