require "solver"

class Application < Sinatra::Base
	set :root, File.dirname(__FILE__)
	set :logging, true

	get '/' do
		haml :index
	end

	get '/solve' do
		nums = params[:n].split(',').map(&:to_i)
		content_type :json
		if nums.size == 0
			[].to_json
		else
			Solver.solve(*nums).to_a.to_json
		end
	end
end
