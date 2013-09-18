class Cell

  attr_accessor :value, :neighbours, :box_id
  ALLOWED_VALUES = (1..9).to_a
  
  def initialize(value=0)
    @neighbours = []
    @value = value
  end

  def filled_in?
    ALLOWED_VALUES.include?(@value)
  end

  def inspect
    "\#<Cell box_id:#{box_id} value:#{value} neighbours:#{'nothing here'}"
  end

  def identify_candidates
    neighbour_values = @neighbours.map{|cell| cell.value}.uniq
    ALLOWED_VALUES - neighbour_values
  end

  def fill_in!
    return if (1..9).include?(@value)
    candidates = identify_candidates
    candidates
    @value = candidates.size == 1 ? candidates[0] : 0
  end

end