class BookmarkManager < Sinatra::Base

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

end
