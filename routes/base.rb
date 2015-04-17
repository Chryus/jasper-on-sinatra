require "sinatra/base"
require "sass"
require "compass"
require "sinatra/asset_pipeline"
require "sinatra/assetpack"
require "rack-flash"
require "./config/initializers/sequel"
require "sinatra/content_for"
require "json"
require "sinatra/prawn"
require "pry-byebug"

Dir["./models/*.rb"].each { |model| require model }
Dir["./helpers/*.rb"].each { |helper| require helper }

module JasperOnSinatra
  module Routes
    class Base < Sinatra::Base
      configure do
        enable :method_override
        enable :static, :logging, :sessions
      end

      before do
        pass if %w[login logout].include? request.path_info.split("/")[1]
        redirect "/login" unless env["warden"].authenticated?
      end

      set :root, File.realpath("..", __dir__)
      set :public_folder, File.realpath("../public", __dir__)

      set :assets_precompile, %w(app.css *.jpg)
      set :assets_prefix, %w(assets)
      set :assets_css_compressor, :sass
      set :assets_js_compressor, :uglifier
      register Sinatra::AssetPipeline
      register Sinatra::AssetPack

      set :erb, format: :html5

      helpers Sinatra::ContentFor

      assets do
        serve "/js", from: "js"
        serve "/bower_components", from: "bower_components"


        js :modernizr, [
          "/bower_components/modernizr/modernizr.js",
        ]

        js :libs, [
          "/bower_components/jquery/dist/jquery.js",
          "/bower_components/foundation/js/foundation.js",
          "/bower_components/foundation/js/foundation/foundation.magellan.js"
        ]

        js :application, [
          "/js/app.js"
        ]

        js_compression :jsmin
      end
    end
  end
end

