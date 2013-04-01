require "solver"

class Application < Sinatra::Base
  set :root, File.dirname(__FILE__)
  set :logging, true

  get '/' do
    haml :index
  end

  get '/solve' do
  	nums = params[:n].split(',').map(&:to_i)
  	Solver.solve(*nums).to_json
  end
end
