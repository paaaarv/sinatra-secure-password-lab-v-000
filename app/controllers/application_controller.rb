require "./config/environment"
require "./app/models/user"
require 'pry'
class ApplicationController < Sinatra::Base

  configure do
    set :views, "app/views"
    enable :sessions
    set :session_secret, "password_security"
  end

  get "/" do
    erb :index
  end

  get "/signup" do
    erb :signup
  end

  post "/signup" do
    if params["username"] == ""
      redirect '/failure'
    elsif params["password"] == ""
      redirect '/failure'
    else
      @user = User.new(username: params['username'], password: params['password'])
      session[:user_id] = @user.id
      redirect '/login'
    end

  end

  get '/account' do
    @user = User.find_by(session[:user_id]) if session[:user_id]
    erb :account
  end


  get "/login" do
    erb :login
  end

  post "/login" do

    @user = User.find_by(username: params['username'], password: ['password'])
    if params["username"] == ""
      redirect '/failure'
    end
    if params["password"] == ""
      redirect '/failure'
    end


    redirect '/account'

  end

  get "/success" do
    if logged_in?
      erb :success
    else
      redirect "/login"
    end
  end

  get "/failure" do
    erb :failure
  end

  get "/logout" do
    session.clear
    redirect "/"
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
