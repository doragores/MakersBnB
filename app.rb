require "sinatra/base"
require "sinatra/reloader"

require "./lib/database_connection.rb"
require "./lib/space.rb"
require "./lib/maker.rb"
require "./lib/space_repository.rb"
require "./lib/maker_repository.rb"

DatabaseConnection.connect("makersbnb_test")

class Application < Sinatra::Base
  enable :sessions

  configure :development do
    register Sinatra::Reloader
    also_reload "lib/maker_repository"
  end

  get "/" do
    space_repo = SpaceRepository.new
    maker_repo = MakersRepository.new
    if session[:maker_id]
      @maker = maker_repo.find(session[:maker_id])
    end
    return erb(:index)
  end

  get "/login" do
    return erb(:login)
  end

  get "/signup" do
    return erb(:signup)
  end

  post "/signup" do
    repo = MakersRepository.new
    new_maker = Makers.new
    new_maker.name = params[:name]
    new_maker.email = params[:email]
    new_maker.password = params[:password]

    repo.create(new_maker)

    return erb(:login)
  end
  # This route receives login information (email and password)
  # as body parameters, and find the user in the database
  # using the email. If the password matches, it returns
  # a success page.
  post "/login" do
    repo = MakersRepository.new

    email = params[:email]
    password = params[:password]

    maker = repo.find_by_email(email)

    # This is a simplified way of
    # checking the password. In a real
    # project, you should encrypt the password
    # stored in the database.

    if maker.password == password
      # Set the user ID in session
      session[:maker_id] = maker.id
      redirect "/spaces"
    else
      return erb(:login)
    end
  end

  get "/logout" do
    session[:maker_id] = nil
    redirect "/"
  end

  get "/spaces" do
    space_repo = SpaceRepository.new
    maker_repo = MakersRepository.new
    if session[:maker_id]
      @maker = maker_repo.find(session[:maker_id])
    end
    @spaces = space_repo.all
    return erb(:spaces)
  end

  get "/spaces/:id" do
    repo = SpaceRepository.new
    @space = repo.find_by_id(params[:id])
    return erb(:space_single)
  end
end
