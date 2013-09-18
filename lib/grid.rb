require_relative 'cell'

class Grid

  BOX_ID = [1,1,1,2,2,2,3,3,3,1,1,1,2,2,2,3,3,3,1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,6,4,4,4,5,5,5,6,6,6,4,4,4,5,5,5,6,6,6,7,7,7,8,8,8,9,9,9,7,7,7,8,8,8,9,9,9,7,7,7,8,8,8,9,9,9]
  attr_accessor :cells, :rows, :columns, :boxes

  def initialize(puzzle)
    @cells = puzzle.chars.map { |c| Cell.new(c.to_i) }
    create_puzzle_rows
    create_puzzle_columns
    @boxes = []
    assign_neighbours
  end

  def create_puzzle_rows
    @rows = []
    @cells.each_slice(9){|n| @rows << n}
    @rows
  end

  def create_puzzle_columns
    @columns = []
    @cells.each_slice(9) {|n| @columns << n}
    @columns = @columns.transpose
  end

  def solved?
    @cells.all? {|c| (1..9).include?(c) }
  end

  def assign_neighbours
    @cells.map! do |cell|
      row_neighbours = get_row_neighbours_for cell
      col_neighbours = get_column_neighbours_for cell
      get_box_id_for cell
      box_neighbours = get_box_neighbours cell
      cell.neighbours = (row_neighbours + col_neighbours + box_neighbours)
      cell
    end
  end

  def get_row_neighbours_for cell
    row_neighbours = @rows.select {|row| row.include? cell}.flatten
    row_neighbours.delete_if{|c| c == cell}
    row_neighbours
  end

  def get_column_neighbours_for cell
    col_neighbours = @columns.select {|col| col.include? cell}.flatten
    col_neighbours.delete_if{|c| c == cell}
  end

  def get_box_neighbours cell
    box_neighbours = @cells.select {|c| c.box_id == cell.box_id}
    box_neighbours.delete_if{|c| c == cell}
  end

  def get_box_id_for cell
    row = @rows.index(@rows.detect {|row| row.include?(cell)})
    column = @columns.index(@columns.detect{|col| col.include?(cell)})
    cell.box_id = BOX_ID[row * 9  + column]
  end

  def solved?
    @cells.count {|c| c.filled_in?} == 81
  end

  def solve
    outstanding_before = @cells.size - @cells.count {|c| c.filled_in?}

    looping = false
    while !solved? && !looping
      @cells.each {|cell| cell.fill_in!}
      outstanding = @cells.count {|c| !c.filled_in?}
      looping = outstanding_before == outstanding
    end
  end

  def to_s
    @cells.map {|cell| cell.value}.join('')
  end
end