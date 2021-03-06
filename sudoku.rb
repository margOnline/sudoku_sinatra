require 'sinatra'
require 'rack-flash'
require_relative './lib/grid'
require 'sinatra/partial'

enable :sessions
use Rack::Flash

set :partial_template_engine, :erb
set :session_secret, "I'm the secret key to sign the cookie"

def random_sudoku
  seed = '015003002000100906270068430490002017501040380003905000900081040860070025037204600'
  sudoku = Grid.new(seed)
  sudoku.solve
  sudoku.to_s.chars  
end

def puzzle(sudoku)
  sudoku
end

def generate_new_puzzle_if_necessary
  return if session[:current_solution]
  sudoku = random_sudoku
  session[:solution] = sudoku
  session[:puzzle] = puzzle(sudoku)
  session[:current_solution] = session[:puzzle]
end

def prepare_to_check_solution
  @check_solution = session[:check_solution]
  if @check_solution
    flash[:notice] = "Incorrect values are highlighted in yellow"
  end
  session[:check_solution] = nil  
end

get '/' do 
  prepare_to_check_solution
  generate_new_puzzle_if_necessary
  @current_solution = session[:solution] || [:puzzle]
  @solution = session[:solution]
  @puzzle = session[:puzzle]
  erb :index
end

get '/solution' do
  @current_solution = session[:solution]
  erb :index
end 

post '/' do
  cells = params["cell"]
  session[:current_solution] = cells.map{|value| value.to_i}.join
  session[:check_solution] = true
  redirect to("/")
end

helpers do

  def colour_class(solution_to_check,puzzle_value,current_solution_value,solution_value)
    must_be_guessed = puzzle_value = 0
    tried_to_guess = current_solution_value.to_i != 0 
    guessed_incorrectly = current_solution_value != solution_value

    if solution_to_check && must_be_guessed && tried_to_guess && guessed_incorrectly
      'incorrect'
    elsif !must_be_guessed
      'value-provided'
    end
  end

  def cell_value(value)
    value.to_i == 0 ? '' : value
  end

end
