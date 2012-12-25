Dir["./models/**/*.rb"].each { |model| require model }

Mongoid.load!('mongoid.yml')

# Assets

class ScssEngine < Sinatra::Base
  set :views, File.dirname(__FILE__) + '/assets/sass'
  get '/styles/*.css' do
    fname = params[:splat].first
    scss fname.to_sym
  end
end

class CoffeeEngine < Sinatra::Base
  set :views, File.dirname(__FILE__) + '/assets/coffeescript'
  get '/scripts/*.js' do
    fname = params[:splat].fist
    coffee fname.to_sym
  end
end

class App < Sinatra::Base
  use ScssEngine
  use CoffeeEngine

  set :views, File.dirname(__FILE__) + '/views'
  set :public_folder, File.dirname(__FILE__) + '/public'

  get '/' do
    slim :index
  end

  get '/grams.json' do
    content_type :json
    photos = Photo.all
    photos.to_json
  end

  not_found do
    'Womp womp does not compute. 404'
  end

  if __FILE__ == $0
    App.run! :port => 4000
  end
end
