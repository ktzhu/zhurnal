Dir["./models/**/*.rb"].each { |model| require model }

Mongoid.load!('mongoid.yml')

# Assets

class ScssEngine < Sinatra::Base
  set :views, File.dirname(__FILE__) + '/assets/scss'
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
  enable :sessions
  use ScssEngine
  use CoffeeEngine

  # Configure reloading for dev
  configure :development do
    register Sinatra::Reloader
  end

  set :views, File.dirname(__FILE__) + '/views'
  set :public_folder, File.dirname(__FILE__) + '/public'
  set :instagram_client_id, URI.parse(ENV['INSTAGRAM_CLIENT_ID'])
  set :instagram_client_secret, URI.parse(ENV['INSTAGRAM_CLIENT_SECRET'])

  # Configure Instagram
  Instagram.configure do |config|
    config.client_id = settings.instagram_client_id
    config.client_secret = settings.instagram_client_secret
  end

  get '/' do
    @photos = Photo.all
    slim :index
  end

  get '/grams.json' do
    content_type :json
    images = Instagram.tag_recent_media('zhugram')
    images = images.data
    images.each do |entry|
      Photo.create(caption: entry.caption.text, url: entry.images.low_resolution.url)
    end
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
