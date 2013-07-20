#app.rb
require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'json'

# Setup DataMapper with local sqlite
DataMapper.setup(:default, "sqlite://#{Dir.pwd}/development.sqlite")

# Define basic User model
class User
	include DataMapper::Resource
	
	property :id, 			Serial, 	:key => true
	property :created_at, 	DateTime
	property :firstName, 	String, 	:length =>255
	property :lastName, 	String, 	:length =>255
end

DataMapper.finalize

# Tell DataMapper to update db for definitions above
DataMapper.auto_upgrade!

# get all users
get '/users' do
    content_type :json
    @users = User.all(:order => :created_at.desc)
    @users.to_json
    
end

# add a new user
# params:
# firstName
# lastName
post '/users' do
	content_type :json
	
	# get hash of post JSON data
	params_json = JSON.parse(request.body.read)
	
	@user = User.new(params_json)
	
	# If the user is successfully stored, return the user json back
	if @user.save
		@user.to_json
	else
	# Otherwise, throw an error!
		halt 500
	end
end

# get specific user by id
get '/users/:id' do
	content_type :json
	@user = User.get(params[:id])
	
	if @user
		@user.to_json
	else
		halt 404
	end
end

# update user by id
put '/users/:id' do
	content_type :json
	
	# get hash of post JSON data
	params_json = JSON.parse(request.body.read)
	
	@user = User.get(params[:id])
	@user.update(params_json)
	
	# If the user is successfully stored, return the user json back
	if @user.save
		@user.to_json
	else
	# Otherwise, throw an error!
		halt 500
	end
end

# remove a user by id
delete '/users/:id' do
	content_type :json
	@user = User.get(params[:id])
	
	if @user.destroy
		{:success => "ok"}.to_json
	else
		halt 500
	end
end
