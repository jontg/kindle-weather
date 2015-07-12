require 'tempfile'
require 'yaml'
require 'twitter'

require 'action_view'
require 'action_view/helpers'
include ActionView::Helpers::DateHelper

class KindleTwitter
	# Constants
	ROOT = File.expand_path(File.join(File.dirname(__FILE__), "..")) # Get the root directory
	CONFIG_FILE = "#{ENV['CONFIG_ROOT'] || "#{ROOT}/config"}/Twitter.conf"

	attr_accessor :credentials

	def initialize
		settings = YAML::load_file(CONFIG_FILE)
		@credentials = settings['credentials']
		@feed = settings["feed"]
	end

	def process
		client = Twitter::REST::Client.new do |config|
			config.consumer_key        = @credentials['api_key']
			config.consumer_secret     = @credentials['api_secret']
			config.access_token        = @credentials['access_token']
			config.access_token_secret = @credentials['token_secret']
		end

		{
			:twitter => {
				:name => @feed,
				:tweets => client.user_timeline(@feed).take(5).map{|t|
					time_ago_in_words(t.created_at) + ' ago: ' + t.full_text
				}
			}
		}
	end
end # class
