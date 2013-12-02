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
    serve '/fonts',  from: 'fonts'

    # The second parameter defines where the compressed version will be served.
    # (Note: that parameter is optional, AssetPack will figure it out.)
    js :app, ['/js/*.js']

    css :application, '/css/application.css', ['/css/screen.css']

    js_compression  :jsmin    # :jsmin | :yui | :closure | :uglify
    css_compression :simple   # :simple | :sass | :yui | :sqwish
  end

end