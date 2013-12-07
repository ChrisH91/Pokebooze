require 'sinatra/base'
require 'sinatra/assetpack'
require 'sass'
require 'coffee_script'


class App < Sinatra::Base

  set :root, File.dirname(__FILE__) # You must set app root
  set :public_folder, File.dirname(__FILE__) + '/public'

  get "/" do
    haml :index
  end

  register Sinatra::AssetPack

  assets do
    serve '/js',     from: 'js'        # Default
    serve '/css',    from: 'css'       # Default
    serve '/images', from: 'images'    # Default

    # The second parameter defines where the compressed version will be served.
    # (Note: that parameter is optional, AssetPack will figure it out.)
    js :app, [
      '/js/kinetic-v4.7.4.min.js',
      '/js/tile.js',
      '/js/app.js',
      '/js/board.js',
      '/js/camera.js',
      '/js/game.js',
      '/js/logger.js',
      '/js/music.js',
      '/js/painter.js',
      '/js/player.js',
      '/js/plotter.js',
      '/js/pokebooze.js',
      '/js/ui.js',
    ]

    css :application, '/css/application.css', ['/css/screen.css']

    js_compression  :jsmin    # :jsmin | :yui | :closure | :uglify
    css_compression :simple   # :simple | :sass | :yui | :sqwish
    prebuild true
  end

end