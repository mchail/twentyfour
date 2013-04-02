$:.unshift File.expand_path("../", __FILE__)
require 'sinatra'
require 'sass'
require 'haml'
require 'sprockets'
require 'uglifier'
require "yui/compressor"
require "json"

require "rack/timeout"
use Rack::Timeout
Rack::Timeout.timeout = 15  # this line is optional. if omitted, default is 15 seconds.

require "application"

map '/assets' do
	environment = Sprockets::Environment.new
	environment.append_path 'assets/javascripts'
	environment.append_path 'assets/stylesheets'
	environment.append_path 'assets/vendor'
	environment.js_compressor = Uglifier.new(:copyright => false)
	environment.css_compressor = YUI::CssCompressor.new
	run environment
end

map '/' do
	run Application
end
