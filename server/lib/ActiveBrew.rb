require 'erb'
require 'tempfile'
require 'yaml'
require 'net/http'
require 'uri'
require 'open-uri'
require 'base64'

class ActiveBrew
	# Constants
	ROOT = File.expand_path(File.join(File.dirname(__FILE__), "..")) # Get the root directory
	CONFIG_FILE = "#{ENV['CONFIG_ROOT'] || "#{ROOT}/config"}/ActiveBrew.conf"

	TEMPERATURE_URL = ERB.new <<-EOU
		https://api.xively.com/v2/feeds/<%= @feed %>/datastreams/<%= @datastream %>.png?w=800&h=175&duration=<%= @duration %>&interval=<%= @interval %>
	EOU
	ICE_TEMPERATURE_URL = ERB.new <<-EOU
		https://api.xively.com/v2/feeds/<%= @feed %>/datastreams/<%= @ice_datastream %>.png?w=800&h=175&duration=<%= @duration %>&interval=<%= @interval %>
	EOU

	attr_accessor :feed, :datastream, :ice_datastream, :duration, :interval

	def initialize
		settings = YAML::load_file(CONFIG_FILE)
		@feed = settings["feed"]
		@datastream = settings["datastream"]
		@ice_datastream = settings["ice_datastream"]
		@duration = settings["duration"]
		@interval = settings["interval"]
		# @api_key = settings["api_key"]
	end

	def fetch_and_parse_temp
		URI.parse(TEMPERATURE_URL.result(binding).strip)
	end

	def fetch_and_parse_ice_temp
		URI.parse(ICE_TEMPERATURE_URL.result(binding).strip)
	end

	def process
		{
			:ice_b64 => open(fetch_and_parse_ice_temp(), "rb") {|src| "data:image/png;base64,"+Base64.encode64(src.read).gsub("\n","")},
			:temp_b64=> open(fetch_and_parse_temp(), "rb") {|src| "data:image/png;base64,"+Base64.encode64(src.read).gsub("\n","")}
		}
  end
end # class
