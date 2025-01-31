require 'sinatra/base'
require 'sinatra/flash'
require './lib/peep'
require './lib/member'
require './lib/database_connection_setup'

class Chitter < Sinatra::Base

  enable :sessions
  register Sinatra::Flash

  get '/' do
    "Welcome to Chitter"
  end

  get '/peeps' do
    @member = Member.find(id: session[:id])
    @peeps = Peep.all
    erb :"peeps/index"
  end

  get '/peeps/new' do
    erb :"peeps/new"
  end

  post '/peeps' do
    Peep.create(peep: params[:peep])
    redirect '/peeps'
  end

  get '/members/new' do
    erb :"members/new"
  end

  post '/members' do
    name = params[:name]
    username = params[:username]
    email = params[:email]
    password = params[:password]
    member = Member.create(
      name: name,
      username: username,
      email: email,
      password: password)
    session[:id] = member.id
    redirect '/peeps'
  end

  get '/sessions/new' do
    erb :"sessions/new"
  end

  post '/sessions' do
    member = Member.authenticate(
      email: params[:email],
      password: params[:password])

    if member
      session[:id] = member.id
      redirect('/peeps')
    else
      flash[:notice] = 'Please check your email or password'
      redirect('/sessions/new')
    end
  end

  post '/sessions/destroy' do
    session.clear
    flash[:notice] = 'You have signed out'
    redirect('/peeps')
  end

  run! if app_file == $0
end
