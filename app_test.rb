require './app'
require 'json'
require 'test/unit'
require 'rack/test'

set :environment, :test

class AppTest < Test::Unit::TestCase
	include Rack::Test::Methods

    def app
    	Sinatra::Application
    end
      
    def test_get_users
    	get '/users'
    	assert last_response.ok?
    end
    
    def test_post_new_user
    	post_json('/users', {:firstName => "Mike", :lastName => "Wazowski"}.to_json)
    	assert last_response.ok?
    end
    
    #helper
    def post_json(uri, json)
    	post(uri, json, {"CONTENT_TYPE" => "application/json"})
    end
end
      		