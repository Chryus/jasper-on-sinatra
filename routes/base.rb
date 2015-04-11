require "sinatra/base"
require "sass"
require "sinatra/content_for"
require "./config/initializers/sequel"
require "pry-byebug"

Dir["./models/*.rb"].each { |model| require model }
Dir["./helpers/*.rb"].each { |helper| require helper }

module JasperOnSinatra
  module Routes
    module Base < Sinatra::Base
      configure do
        enable :method_override
        enable :static, :logging
      end

      before do
        pass if %w[login logout].include? request.path_info.split('/')[1]
        redirect "/login" unless env["warden"].authenticated?
      end

      set :root, File.realpath("..", __dir__)
      set :public_folder, File.realpath("../public", __dir__)

      set :assets_precompile, %w(app.css *.jpg)
      set :assets_prefix, %w(assets)
      set :assets_css_compressor, :sass
      set :assets_js_compressor, :uglifier
      register Sinatra::AssetPipeline

      set :erb, format: :html5

      helpers Sinatra::ContentFor, FlashHelper, TextHelper, DateHelper, NamedRoutes
    end
  end
end

