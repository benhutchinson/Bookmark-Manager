class BookmarkManager < Sinatra::Base

  post '/users' do 
    @user = User.create(:email => params[:email], 
                :password => params[:password],
                :password_confirmation => params[:password_confirmation]
                )
    
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

  get '/users/forgot_password' do
    erb :"users/forgot_password"
  end    

  post '/users/forgot_password' do 
    flash[:notice] = "Please check your email." 
    user = User.first(email: params[:email])
    user.password_token = (1..64).map{('A'..'Z').to_a.sample}.join
    user.password_token_timestamp = Time.now
    user.save

    mg_client = Mailgun::Client.new ENV['MY_MAILGUN_KEY']
    message_params = {:from    => ENV['MY_MAILGUN_SANDBOX'],
                  :to      => ENV['MY_MAILGUN_EMAIL'],
                  :subject => 'Reset Your Password',
                  :text    => 'Time to do this.'}
    mg_client.send_message ENV['MY_MAILGUN_SANDBOX2'], message_params

    redirect '/'
  end

  get '/users/reset_password/:token' do 
    @token = params[:token]
    user = User.first(password_token: @token)
    erb :"users/resets_password"
  end

  post '/users/reset_password' do
    flash[:notice] = "Password successfully reset."
    user = User.first(password_token: params[:password_token])
    user.update(password: params[:password], password_confirmation: params[:password_confirmation], password_token: nil)
    redirect '/'
  end

end
