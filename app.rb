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
  get '/js/*.js' do
    fname = params[:splat].first
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
  set :instagram_client_id, URI.parse(ENV['INSTAGRAM_CLIENT_ID']).to_s
  set :instagram_client_secret, URI.parse(ENV['INSTAGRAM_CLIENT_SECRET']).to_s
  set :twitter_consumer_key, URI.parse(ENV['TWITTER_CONSUMER_KEY']).to_s
  set :twitter_consumer_secret, URI.parse(ENV['TWITTER_CONSUMER_SECRET']).to_s
  set :twitter_oauth_token, URI.parse(ENV['TWITTER_OAUTH_TOKEN']).to_s
  set :twitter_oauth_token_secret, URI.parse(ENV['TWITTER_OAUTH_TOKEN_SECRET']).to_s

  # Configure Instagram
  Instagram.configure do |config|
    config.client_id = settings.instagram_client_id
    config.client_secret = settings.instagram_client_secret
  end

  # Configure Twitter
  Twitter.configure do |config|
    config.consumer_key = settings.twitter_consumer_key
    config.consumer_secret = settings.twitter_consumer_secret
    config.oauth_token = settings.twitter_oauth_token
    config.oauth_token_secret = settings.twitter_oauth_token_secret
  end

  get '/' do
    @photos = Photo.order_by(:created_at => :desc)
    @tweets = Quote.order_by(:created_at => :desc)
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

  get '/tweets.json' do
    content_type :json
    begin
      @zhuuuba = Twitter.user_timeline('zhuuuba', count: 3000)
      # @zhuisms = Twitter.search('#zhuisms -rt')
      @zhuuuba.each do |tweet|
        unless tweet.text.split.drop_while { |x| x != 'dad' }.empty?
          Quote.create(content: tweet.text, speaker: 'Dad')
        end
        unless tweet.text.split.drop_while { |x| x != 'mom' }
          Quote.create(content: tweet.text, speaker: 'Mom').empty?
        end
      end

      @kzhu91 = Twitter.user_timeline('kzhu91', count: 3000)
      @kzhu91.each do |tweet|
        unless tweet.text.gsub(/\,/,"").split.drop_while { |x| x != 'dad' }.empty?
          Quote.create(content: tweet.text, speaker: 'Dad')
          puts tweet.text
        end
        unless tweet.text.gsub(/\,/, "").split.drop_while { |x| x != 'mom' }.empty?
          Quote.create(content: tweet.text, speaker: 'Mom')
          puts tweet.text
        end
      end
    rescue Twitter::Error => e
      puts e
    end
    @kzhu91.to_json
  end

  not_found do
    'Womp womp does not compute. 404'
  end

  if __FILE__ == $0
    App.run! :port => 4000
  end
end
