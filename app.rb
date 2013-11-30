require 'sinatra/base'
require 'sinatra/assetpack'
require 'sass'

class App < Sinatra::Base

  get "/" do
    haml :index
  end

  set :root, File.dirname(__FILE__) # You must set app root

  register Sinatra::AssetPack

  assets {
    serve '/js',     from: 'js'        # Default
    serve '/css',    from: 'css'       # Default
    serve '/images', from: 'images'    # Default

    # The second parameter defines where the compressed version will be served.
    # (Note: that parameter is optional, AssetPack will figure it out.)
    js :app, [
      '/js/kinetic-v4.7.4.min.js',
      '/js/tile.js',
      '/js/board.js',
      '/js/player.js',
      '/js/game.js',
      '/js/app.js',
    ]

    css :application, '/css/application.css', [
      '/css/screen.css'
    ]

    js_compression  :jsmin    # :jsmin | :yui | :closure | :uglify
    css_compression :simple   # :simple | :sass | :yui | :sqwish
  }

end