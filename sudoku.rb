require 'sinatra'
require_relative './lib/grid'


def random_sudoku
  seed = '015003002000100906270068430490002017501040380003905000900081040860070025037204600'
  sudoku = Grid.new(seed)
  sudoku.solve
  sudoku.to_s.chars
  
end


get '/' do 
  @current_solution = random_sudoku
  puts @current_solution.inspect
  erb :index
end