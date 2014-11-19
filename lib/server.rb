require 'sinatra/base'
require 'data_mapper'
require 'rack-flash'
require './lib/link'
require './lib/tag'
require './lib/user'
require_relative './helpers/application'
require_relative 'data_mapper_setup'
# i.e. this bit is declaring the models

class BookmarkManager < Sinatra::Base

  include Helpers

  enable :sessions
  set :session_secret, 'super secret'
  use Rack::Flash
  use Rack::MethodOverride

  get '/' do 
    @links = Link.all
    erb :index
  end

  post '/links' do 
    url = params["url"]
    title = params["title"]
    tags = params["tags"].split(" ").map do |tag|
      Tag.first_or_create(:text => tag)
    end
    Link.create(:url => url, :title => title, :tags => tags)
    redirect to('/')
  end

  get '/tags/:text' do 
    tag = Tag.first(:text => params[:text])
    # first here is a Datamapper method
    # i.e. finding the Tag that has the string defined by the text 
    # parameter in the URL
    @links = (tag ? tag.links : [])
    # so this returns an empty array if tag is nil effectively
    # i.e. if tag did not find any Tag with the text defined
    # in the parameter in the URL
    erb :index
  end

  post '/users' do 
    @user = User.create(:email => params[:email], 
                :password => params[:password],
                :password_confirmation => params[:password_confirmation])
    
    if @user.save
      session[:user_id] = @user.id
      # user id would be nil if the user wasn't saved
      # because of a password mis-match
      # ref DataMapper validates_confirmation_of
      # method in User.rb model
      # i.e. user.save is only going to happen
      # if valid due to validates_confirmation_of
      redirect to('/')
    else
      flash.now[:errors] = @user.errors.full_messages
      erb :"users/new"
      # i.e. if not valid, the same form will
      # be shown again but the information
      # that was previously submitted should not be lost
      # this is possible as @user was defined in /users/new
      # below and this was called in the Email text input field
    end

  end

  get '/users/new' do 
    @user = User.new
    erb :"users/new"
    # i.e. erb file is in a directory
    # views/users/new.erb (rather than
    # just in views/new.erb ) so need
    # to make that location clear.
    # without "", ruby would try to 
    # divide users by new.
  end

  get '/sessions/new' do 
    erb :"sessions/new"
  end

  post '/sessions' do 
    email, password = params[:email], params[:password]
    user = User.authenticate(email, password)
    if user
      session[:user_id] = user.id
      redirect to('/')
    else
      flash[:errors] = ["The email or password is incorrect"]
      erb :"sessions/new"
    end
  end

  delete '/sessions' do 
    flash[:notice] = "Goodbye!"
    session[:user_id] = nil
    redirect to ('/')
  end


  # start the server if ruby file executed directly
  run! if app_file == $0
end
