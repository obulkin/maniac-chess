class King < Piece
	def valid_move?(new_rank, new_file)
		rank_diff = (new_rank - rank).abs
		file_diff = (new_file - file).abs
		if !is_move_malformed?(new_rank, new_file) && (rank_diff <= 1) && (file_diff <= 1) && !is_move_obstructed?(new_rank, new_file)
			true			
		else
			false
		end	
	end
end
