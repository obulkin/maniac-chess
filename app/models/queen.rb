class Queen < Piece

  def image
    if color == 'white'
      return '&#9813;'
    else
      return '&#9819;'
    end
  end
end