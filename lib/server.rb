require 'sinatra/base'
require 'sinatra/partial'
require 'data_mapper'
require 'rack-flash'
require 'mailgun'
require './lib/link'
require './lib/tag'
require './lib/user'
# i.e. this bit is declaring the models
require_relative './helpers/application'
require_relative 'data_mapper_setup'
require_relative './controllers/users'
require_relative './controllers/sessions'
require_relative './controllers/tags'
require_relative './controllers/links'
require_relative './controllers/application'

class BookmarkManager < Sinatra::Base

  set :views, Proc.new { File.join(root, "../views") }
  set :public_folder, Proc.new { File.join(root, "../../public") }
  register Sinatra::Partial

  include Helpers

  enable :sessions
  set :session_secret, 'super secret'
  set :partial_template_engine, :erb
  enable :partial_underscores
  use Rack::Flash
  use Rack::MethodOverride

  # start the server if ruby file executed directly
  run! if app_file == $0
end
